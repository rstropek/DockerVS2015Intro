#Create Volume
Docker volume create EventDB

#Start MongoDB
docker run --name MongoDB -d -v EventDB:/data/db mongo

#Build Node Server
docker build --tag nodeserver NodeMongo
#Run Node Server
docker run -d --link=MongoDB:MongoDB -e MONGO_URL=mongodb://MongoDB:27017/member-management --name server nodeserver

#Build WebServer
docker build --tag nodeui NodeMongo.UI
#Run WebServer
docker run -d --name nodeui nodeui

#Build ApplicationGateway
docker build --tag appgateway ApplicationGateway


