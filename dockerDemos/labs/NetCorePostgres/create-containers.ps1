# Docker volume für PostgresDB
docker volume create PostgresDBVolume

# Postgres DB container
docker run --name Postgres -d `
    -e POSTGRES_PASSWORD=P@ssw0rd! `
    -e PGDATA=/usr/stiwa/pgdata `
    -v PostgresDBVolume:/usr/stiwa/pgdata `
    postgres

# Compile container
docker run --rm `
    -v C:\temp\demo-codingdojo\code:/code `
    -w /code `
    --link=Postgres:db_link `
    microsoft/dotnet /bin/bash -c "dotnet build && dotnet ef migrations add InitialCreate && dotnet ef database update"

# Start WebAPI Container
docker run -d --name WebAPI1 `
    -v C:\temp\demo-codingdojo\code:/code `
    -w /code `
    --link=Postgres:db_link `
    -e ASPNETCORE_URLS=http://*:49981 `
    microsoft/dotnet dotnet run

docker run -d --name WebAPI2 `
    -v C:\temp\demo-codingdojo\code:/code `
    -w /code `
    --link=Postgres:db_link `
    -e ASPNETCORE_URLS=http://*:49981 `
    microsoft/dotnet dotnet run

# LoadBalancer
docker run -d --name LoadBalancer `
    --link=WebAPI1:WebAPI1 `
    --link=WebAPI2:WebAPI2 `
    -p 8082:80 `
    -v C:\temp\demo-codingdojo\code\nginx.conf:/etc/nginx/nginx.conf `
    nginx:alpine