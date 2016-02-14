FROM microsoft/aspnet

RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install -y nodejs

COPY ./my-web /src

RUN cd /src && dnu restore

EXPOSE 5000

WORKDIR /src
CMD ["dnx", "web"]
