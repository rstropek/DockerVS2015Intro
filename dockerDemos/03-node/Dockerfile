FROM ubuntu

RUN sudo apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
RUN sudo apt-get install -y nodejs

COPY . /src
RUN cd /src; npm install

EXPOSE 1337
CMD ["node", "/src/server.js"]

