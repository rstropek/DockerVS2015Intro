apt-get update

# Install nodejs and npm
apt-get install -y nodejs
apt-get install -y npm
npm install npm -g
ln -s /usr/bin/nodejs /usr/bin/node

# Install Azure XPlat tools
npm install azure-cli -g

# Install Docker
curl -sSL https://get.docker.com/ubuntu/ | sh

