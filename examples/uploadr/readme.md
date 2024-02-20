# Important Commands

## Volume

```bash
docker volume create uploader-files
docker volume create database-files
docker network create uploader-net
```

## Uploader.Api

```bash
cd Uploader.Api
dotnet build
dotnet publish -o ../out/Uploader.Api

cd ..
docker run \
    --rm \
    --name uploader \
    -v $(pwd)/out/Uploader.Api:/app \
    -w /app \
    -e UploadSettings__TargetFolder=/app/uploads \
    -p 8080:8080 \
    --mount source=uploader-files,target=/app/uploads \
    --net uploader-net \
    mcr.microsoft.com/dotnet/aspnet:8.0 \
    ./Uploader.Api
```

## Processor

```bash
cd Uploader.Processor
dotnet build
dotnet publish -o ../out/Uploader.Processor

cd ..
docker run \
    --rm \
    --name processor \
    -v $(pwd)/out/Uploader.Processor:/app \
    -w /app \
    -e UploadSettings__TargetFolder=/app/uploads \
    --mount source=uploader-files,target=/app/uploads \
    --net uploader-net \
    mcr.microsoft.com/dotnet/runtime:8.0 \
    ./Uploader.Processor
```

## Database

```bash
docker run \
    -d \
    --name sqlserver \
    --mount source=database-files,target=/var/opt/mssql \
    -e ACCEPT_EULA=Y \
    -e 'MSSQL_SA_PASSWORD=mySecre1~8assw0rd' \
    -e "MSSQL_PID=Express" \
    -p 1433:1433 \
    --net uploader-net \
    mcr.microsoft.com/mssql/server:latest
```
