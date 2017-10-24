FROM microsoft/windowsservercore

# Install Chocolatey (see https://chocolatey.org/install#install-with-cmdexe)
RUN powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command \
    "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

# Install Sleeve prerequisites (see https://github.com/yaronyg/sleeveforarm)

# Use Chocolatey to install git, Node.js, MySQL and Azure CLI
RUN choco install -y \
    git \
    nodejs \
    mysql \
    azure-cli

# Use NPM to install Sleeve globally
RUN npm install sleeveforarm -g
