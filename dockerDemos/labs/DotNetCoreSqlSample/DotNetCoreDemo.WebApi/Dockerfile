FROM microsoft/dotnet:sdk AS builder
COPY . /app/
WORKDIR /app
RUN dotnet publish -o ./out -c Release

FROM microsoft/dotnet:2.1-aspnetcore-runtime-alpine
WORKDIR /app
COPY --from=builder /app/out/ .
CMD ["dotnet", "DotNetCoreDemo.WebApi.dll"]
