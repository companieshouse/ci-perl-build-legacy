FROM centos:6.7

ARG node_js_version=v6.17.1
ARG node_js_package=node-${node_js_version}-linux-x64

RUN sed -i '/^mirrorlist/s/^/#/;/^#baseurl/{s/#//;s/mirror.centos.org\/centos\/$releasever/linuxsoft.cern.ch\/centos-vault\/6.7/}' /etc/yum.repos.d/CentOS-Base.repo

RUN yum install -y \
    zip \
    unzip \
    bzip2 \
    centos-release-scl \
    expat-devel \
    gcc \
    gcc-c++ \
    tar \
    texlive-latex \
    openssl-devel \
    perl-core \
    libxslt-devel-1.1.26

RUN sed -i '/^baseurl/s/mirror.centos.org\/centos\/6/linuxsoft.cern.ch\/centos-vault\/6.7/' /etc/yum.repos.d/{CentOS-SCLo-scl-rh.repo,CentOS-SCLo-scl.repo}

RUN yum update -y \
    ca-certificates \
    curl \
    nss

RUN curl -L http://cpanmin.us -o /usr/local/bin/cpanm \
    && chmod u+x /usr/local/bin/cpanm

RUN cpanm Algorithm::Diff@1.1903 \
    Term::ANSIColor@2.02 \
    Test::Deep@1.130 \
    Moose@2.2013 \
    Devel::Declare@0.006022

RUN	curl --tlsv1 -kLO https://nodejs.org/download/release/${node_js_version}/${node_js_package}.tar.gz \
    && tar -C /usr/local -zxf ${node_js_package}.tar.gz

ENV PATH /usr/local/${node_js_package}/bin:$PATH
