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
ENV MONGO_DRIVER_VERSION 2.2
ENV MONGO_DRIVER_PATCH_VERSION 3
RUN wget http://downloads.mongodb.org/cxx-driver/mongodb-linux-x86_64-$MONGO_DRIVER_VERSION.$MONGO_DRIVER_PATCH_VERSION.tgz && \
    tar xfvz mongodb-linux-x86_64-$MONGO_DRIVER_VERSION.$MONGO_DRIVER_PATCH_VERSION.tgz && \
    cd mongo-cxx-driver-v$MONGO_DRIVER_VERSION && \
      scons && \
      sudo scons install && \
      sudo chmod a+r -R /usr/local/include/mongo && \
      cd .. && \
    rm mongodb-linux-x86_64-$MONGO_DRIVER_VERSION.$MONGO_DRIVER_PATCH_VERSION.tgz && \
    rm -R mongo-cxx-driver-v$MONGO_DRIVER_VERSION

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
