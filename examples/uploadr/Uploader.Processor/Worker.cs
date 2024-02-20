using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Options;

namespace Uploader.Processor;

public class Worker(ILogger<Worker> logger, IOptions<UploadSettings> settings, IOptions<ConnectionStrings> connectionStrings) : BackgroundService
{
    private readonly ILogger<Worker> _logger = logger;

    public override async Task StartAsync(CancellationToken cancellationToken)
    {
        if (!Directory.Exists(settings.Value.TargetFolder))
        {
            Directory.CreateDirectory(settings.Value.TargetFolder);
        }

        // Create database "Uploads" if it doesn't exist
        var connectionString = connectionStrings.Value.DefaultConnection;
        var masterConnectionString = $"{connectionString};Database=master";
        using (var connection = new SqlConnection(masterConnectionString))
        {
            await connection.OpenAsync(cancellationToken);
            using var command = connection.CreateCommand();
            command.CommandText = """
                IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Uploads') BEGIN
                    CREATE DATABASE Uploads
                END
                """;
            await command.ExecuteNonQueryAsync(cancellationToken);
        }

        // Create table "CustomerRevenues" with columns CustomerID and Revenue if it doesn't exist
        var uploadsConnectionString = $"{connectionString};Database=Uploads";
        using (var uploadsConnection = new SqlConnection(uploadsConnectionString))
        {
            await uploadsConnection.OpenAsync(cancellationToken);
            using var uploadsCommand = uploadsConnection.CreateCommand();
            uploadsCommand.CommandText = """
                IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'CustomerRevenues') BEGIN
                    CREATE TABLE CustomerRevenues (
                        Run uniqueidentifier,
                        CustomerID int,
                        Revenue decimal(18, 2),
                        PRIMARY KEY(Run, CustomerID))
                END
                """;

            await uploadsCommand.ExecuteNonQueryAsync(cancellationToken);
        }

        await base.StartAsync(cancellationToken);
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            var files = Directory.GetFiles(settings.Value.TargetFolder, "*.csv");
            foreach (var file in files)
            {
                _logger.LogInformation("Processing {File}", file);

                // Read the file and insert the data into the database
                var lines = File.ReadAllLines(file).Skip(1);
                var rows = lines
                    .Select(line => line.Split(";"))
                    .Select(columns => new { CustomerID = int.Parse(columns[0]), Revenue = decimal.Parse(columns[1]) });
                var uploadsConnectionString = $"{connectionStrings.Value.DefaultConnection};Database=Uploads";
                using (var uploadsConnection = new SqlConnection(uploadsConnectionString))
                {
                    await uploadsConnection.OpenAsync(stoppingToken);
                    using var uploadsCommand = uploadsConnection.CreateCommand();
                    uploadsCommand.CommandText = "INSERT INTO CustomerRevenues (Run, CustomerID, Revenue) VALUES (@Run, @CustomerID, @Revenue)";
                    var run = Guid.NewGuid();
                    foreach (var row in rows)
                    {
                        uploadsCommand.Parameters.Clear();
                        uploadsCommand.Parameters.AddWithValue("@Run", run);
                        uploadsCommand.Parameters.AddWithValue("@CustomerID", row.CustomerID);
                        uploadsCommand.Parameters.AddWithValue("@Revenue", row.Revenue);
                        await uploadsCommand.ExecuteNonQueryAsync(stoppingToken);
                    }
                }

                File.Delete(file);
            }

            await Task.Delay(1000, stoppingToken);
        }
    }
}
