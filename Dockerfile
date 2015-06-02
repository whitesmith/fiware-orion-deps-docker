FROM centos:6.6
MAINTAINER José Ribeiro <jlbribeiro@whitesmith.co>

RUN yum install -y wget tar sudo bzip2 git
RUN sed -i "s/requiretty/\!requiretty/" /etc/sudoers

# Setting up the EPEL6 repo
RUN wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm &&\
    sudo rpm -ivh epel-release-6-8.noarch.rpm

# Major building utils
RUN sudo yum install -y \
      make \
      cmake \
      gcc-c++ \
      scons \
      libmicrohttpd-devel \
      boost-devel \
      libcurl-devel

# MongoDB C++ Driver
# https://github.com/telefonicaid/fiware-orion/commit/70f72baf8a36bc595719ede2e26159cbba8d9722
# documents the regression to legacy-1.0.2 (previously version 2.2.3).
ENV MONGO_DRIVER_VERSION 1.0.2
RUN wget https://github.com/mongodb/mongo-cxx-driver/archive/legacy-$MONGO_DRIVER_VERSION.tar.gz && \
    tar xfvz legacy-$MONGO_DRIVER_VERSION.tar.gz && \
    cd mongo-cxx-driver-legacy-$MONGO_DRIVER_VERSION && \
      scons && \
      sudo scons install --prefix=/usr/local && \
      cd .. && \
    rm legacy-$MONGO_DRIVER_VERSION.tar.gz && \
    rm -R mongo-cxx-driver-legacy-$MONGO_DRIVER_VERSION

# cantcoap
RUN sudo yum install -y \
      clang \
      CUnit-devel

ENV CANTCOAP_VERSION_HASH 749e22376664dd3adae17492090e58882d3b28a7
RUN git clone https://github.com/staropram/cantcoap && \
    cd cantcoap && \
      git checkout $CANTCOAP_VERSION_HASH && \
      make && \
      sudo cp cantcoap.h /usr/local/include && \
      sudo cp dbg.h /usr/local/include && \
      sudo cp nethelper.h /usr/local/include && \
      sudo cp libcantcoap.a /usr/local/lib && \
      cd .. && \
    rm -R cantcoap

# A COAP client (from the libcoap sources)
ENV LIBCOAP_VERSION 4.1.1
RUN wget http://sourceforge.net/projects/libcoap/files/coap-18/libcoap-$LIBCOAP_VERSION.tar.gz/download && \
    mv download libcoap-$LIBCOAP_VERSION.tar.gz && \
    tar xvzf libcoap-$LIBCOAP_VERSION.tar.gz && \
    cd libcoap-$LIBCOAP_VERSION && \
      ./configure && \
      make && \
      sudo cp examples/coap-client /usr/local/bin && \
      cd .. && \
    rm libcoap-$LIBCOAP_VERSION.tar.gz && \
    rm -R libcoap-$LIBCOAP_VERSION
