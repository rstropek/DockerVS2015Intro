# Dockerfile for ASP.NET Image
# Based on Microsoft's standard image (see https://github.com/aspnet/aspnet-docker)
FROM mono
MAINTAINER Rainer Stropek "rainer@timecockpit.com"
ENV REFRESHED_AT 2015-01-02

# Set some env variables that control installation process
ENV KRE_VERSION 1.0.0-beta1
ENV LIBUV_VERSION 1.0.0-rc2
ENV KRE_USER_HOME /opt/kre

# Make sure everything is up to date
RUN apt-get -qq update

# Install packages we will need to setup ASP.NET vNext
RUN apt-get -qqy install unzip gyp wget build-essential

# Install a compatible version of libuv (for details
# see http://www.ganshani.com/blog/2014/12/shell-script-to-setup-net-on-linux/)
WORKDIR /tmp/
RUN wget http://dist.libuv.org/dist/v${LIBUV_VERSION}/libuv-v${LIBUV_VERSION}.tar.gz
RUN tar -xvf libuv-v${LIBUV_VERSION}.tar.gz
WORKDIR libuv-v${LIBUV_VERSION}
RUN ./gyp_uv.py -f make -Duv_library=shared_library
RUN make -C out
RUN cp out/Debug/lib.target/libuv.so /usr/lib/libuv.so.${LIBUV_VERSION}
RUN ln -s libuv.so.${LIBUV_VERSION} /usr/lib/libuv.so.1

# Install ASP.NET vNext (for details see https://github.com/aspnet/Home)
# and set the PATH so that k commands are found
RUN curl -sSL https://raw.githubusercontent.com/aspnet/Home/v${KRE_VERSION}/kvminstall.sh | sh
RUN bash -c "source ${KRE_USER_HOME}/kvm/kvm.sh \
        && kvm install ${KRE_VERSION} -a default \
        && kvm alias default | xargs -i ln -s ${KRE_USER_HOME}/packages/{} ${KRE_USER_HOME}/packages/default"
ENV PATH $PATH:${KRE_USER_HOME}/packages/default/bin
