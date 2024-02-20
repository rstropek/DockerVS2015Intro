namespace Uploader.Processor;

public record UploadSettings(string TargetFolder) {
    public UploadSettings() : this("") { }
}

public record ConnectionStrings(string DefaultConnection) {
    public ConnectionStrings() : this("") { }
}

