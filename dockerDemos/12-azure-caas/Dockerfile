FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /app
COPY *.csproj ./
RUN dotnet restore

# copy everything else and build app
COPY ./ ./
RUN dotnet publish -c release -o out

FROM microsoft/dotnet:2.1-aspnetcore-runtime-alpine AS runtime
ENV ASPNETCORE_URLS=http://*:80
WORKDIR /app
COPY --from=build /app/out ./
ENTRYPOINT ["dotnet", "./src.dll"]
