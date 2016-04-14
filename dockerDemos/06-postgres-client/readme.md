# ASP.NET Core Postgres Client

## Introduction

This sample can be used together with the previous Postgres-sample. It implements
a very simple RESTful Web API accessing the Postgres DB running in a separate container.

Note that the sample code reads the DB host name from an environment variable. In the
previous sample, the Postgres port has been opened on the Docker host. Therefore, you
can access it over the internet while debugging in Visual Studio.

## Storybook

1. Show the previous Postgres DB demo so that you have the DB running in a container filled with sample data.

2. Create an empty ASP.NET Core app.

3. Change `project.json` as follows:
    1. Remove dependency on `IISPlatformHandler` (we don't use IIS in this sample)
    2. Remove full framework
    3. Add `--server.urls http://*:5000` to the `web` command for Kestrel so that it is not limited to `localhost`
    4. Add dependencies to `Npgsql` and `Dapper`

4. Implement web api as shown in `Startup.cs`.

5. Run the `web` command in the debugger, do a code walkthrough.

6. Build the Docker image using the `Dockerfile`: `docker build -t mywebapi .`

7. Run Container: `docker run -d --name webapi --link mydb -p 80:5000 mywebapi`

8. Show that web api now runs inside docker and uses our DB container.
