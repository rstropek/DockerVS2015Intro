FROM microsoft/aspnet
ENV POSTGRES_HOST mydb
WORKDIR /src
COPY project.json .
RUN ["dnu", "restore"]
COPY ./ ./
ENTRYPOINT ["dnx", "web"]