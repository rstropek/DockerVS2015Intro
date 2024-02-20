using Uploader.Processor;

var builder = Host.CreateApplicationBuilder(args);
builder.Services.Configure<UploadSettings>(builder.Configuration.GetSection(nameof(UploadSettings)));
builder.Services.Configure<ConnectionStrings>(builder.Configuration.GetSection(nameof(ConnectionStrings)));
builder.Services.AddHostedService<Worker>();

var host = builder.Build();
host.Run();
