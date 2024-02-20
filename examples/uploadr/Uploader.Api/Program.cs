using Microsoft.Extensions.Options;

var builder = WebApplication.CreateSlimBuilder(args);
builder.Services.AddCors();
builder.Services.Configure<UploadSettings>(builder.Configuration.GetSection(nameof(UploadSettings)));
var app = builder.Build();

app.UseCors(policy => policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
app.MapGet("/", () => "Hello World!");
app.MapPost("/upload", async (HttpRequest req, IOptions<UploadSettings> settings) =>
{
    if (!req.HasFormContentType)
    {
        return Results.BadRequest("This request is not a form submission.");
    }

    var form = await req.ReadFormAsync();
    var file = form.Files["file"];

    if (file is null)
    {
        return Results.BadRequest("No file uploaded.");
    }

    if (!Directory.Exists(settings.Value.TargetFolder))
    {
        Directory.CreateDirectory(settings.Value.TargetFolder);
    }

    var filePath = Path.Combine(settings.Value.TargetFolder, file.FileName);
    using (var stream = new FileStream(filePath, FileMode.Create))
    {
        await file.CopyToAsync(stream);
    }

    return Results.Ok($"File {file.FileName} uploaded successfully.");
});

app.Run();

public record UploadSettings(string TargetFolder) {
    public UploadSettings() : this("") { }
}
