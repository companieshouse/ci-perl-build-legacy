FROM centos:6.7

RUN yum install -y \
    bzip2 \
    centos-release-scl \
    gcc \
    gcc-c++ \
    tar \
    openssl \
    perl-core \
    libxslt-devel-1.1.26

RUN yum update -y \
    ca-certificates \
    curl \
    nss

RUN curl -L http://cpanmin.us -o /bin/cpanm \
    && chmod u+x /usr/local/bin/cpanm
