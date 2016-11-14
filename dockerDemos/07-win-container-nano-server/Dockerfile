FROM microsoft/nanoserver

RUN mkdir c:\install

COPY unattend.xml c:\install
COPY Microsoft-NanoServer-IIS-Package.cab c:\packages/Microsoft-NanoServer-IIS-Package.cab
COPY Microsoft-NanoServer-IIS-Package_en-us.cab c:\packages/en-us/Microsoft-NanoServer-IIS-Package_en-us.cab

WORKDIR c:\\install
RUN dism /online /apply-unattend:.\unattend.xml

RUN echo Hello World > c:\inetpub\wwwroot\greet.html

# Sets a command or process that will run each time a container is run from the new image.
CMD [ "cmd" ]
