FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS dev
WORKDIR /app
COPY ./ShareForFuture/*.csproj ./ShareForFuture/
COPY ./ShareForFuture.Data/*.csproj ./ShareForFuture.Data/
COPY ./ShareForFuture.Data.Tests/*.csproj ./ShareForFuture.Data.Tests/
COPY *.sln ./
RUN dotnet restore
COPY . .

FROM dev AS test
WORKDIR /app
CMD ["dotnet", "test"]

FROM dev AS build
WORKDIR /app
RUN dotnet publish ShareForFuture/ShareForFuture.csproj -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine
WORKDIR /app
COPY --from=build /app/out .
CMD ["dotnet", "ShareForFuture.dll"]
