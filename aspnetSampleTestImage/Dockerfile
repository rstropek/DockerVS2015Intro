# Image for testing ASP.NET vNext samples
FROM microsoft/aspnet:1.0.0-rc1-update1-coreclr
MAINTAINER Rainer Stropek "rainer@timecockpit.com"
ENV REFRESHED_AT 2015-12-17

# Here we will place the source code that should be run
ENV SOURCE_DIR /app/src

# Create directory that will receive sourcecode
RUN mkdir -p $SOURCE_DIR
WORKDIR $SOURCE_DIR

# Copy the script that will run whenever we start a new container
# from this image. The script will fetch the latest source code
# from GitHub, restore packages, and run kestrel web server.
COPY refreshAndRunSample.sh $SOURCE_DIR/
RUN chmod a+x $SOURCE_DIR/refreshAndRunSample.sh

# Get the initial version of the ASP.NET vNext sample and restore
# packages. In practice you could e.g. get your application's code
# from a git repository.
RUN apt-get update
RUN apt-get -qqy install git
RUN apt-get -qqy install libc6-dev
RUN git init 
RUN git pull https://github.com/aspnet/Home.git
RUN cd  samples/1.0.0-rc1-update1/HelloMvc/
RUN dnu restore

ENTRYPOINT ["/app/src/refreshAndRunSample.sh"]
