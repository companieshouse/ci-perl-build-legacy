FROM centos:6.7

ARG node_js_version=v6.17.1
ARG node_js_package=node-${node_js_version}-linux-x64
ARG ruby_main_version=2.3
ARG ruby_version=ruby-${ruby_main_version}.4
ARG bundler_version=1.15.0

RUN sed -i '/^mirrorlist/s/^/#/;/^#baseurl/{s/#//;s/mirror.centos.org\/centos\/$releasever/linuxsoft.cern.ch\/centos-vault\/6.7/}' /etc/yum.repos.d/CentOS-Base.repo

RUN printf '[chpublic]\nname=CH Public RPMs\nbaseurl=http://s3-eu-west-1.amazonaws.com/ch-public-rpms/\nenabled=1\ngpgcheck=0' > /etc/yum.repos.d/chpublic.repo

RUN yum install -y \
    xerces-c-legacy \
    zip \
    unzip \
    bzip2 \
    git \
    patch \
    file \
    centos-release-scl \
    expat-devel \
    gcc \
    gcc-c++ \
    tar \
    texlive-latex \
    openssl-devel \
    perl-core \
    mod_perl \
    libxslt-devel-1.1.26 \
    httpd-devel

RUN sed -i '/^baseurl/s/mirror.centos.org\/centos\/6/linuxsoft.cern.ch\/centos-vault\/6.7/' /etc/yum.repos.d/{CentOS-SCLo-scl-rh.repo,CentOS-SCLo-scl.repo}

RUN yum update -y \
    ca-certificates \
    curl \
    nss

RUN curl -L http://cpanmin.us -o /usr/local/bin/cpanm \
    && chmod u+x /usr/local/bin/cpanm

RUN yum install -y \
    epel-release

RUN cpanm Algorithm::Diff@1.1903 \
    Data::OptList@0.110 \
    Term::ANSIColor@2.02 \
    Test::Deep@1.130 \
    Moose@2.2013 \
    Devel::Declare@0.006022 \
    ExtUtils::XSBuilder@0.28 \
    Apache::Test@1.43 \
    ModPerl::MM \
    Apache2::Cookie@2.13

RUN curl --tlsv1 -kLO https://nodejs.org/download/release/${node_js_version}/${node_js_package}.tar.gz \
    && tar -C /usr/local -zxf ${node_js_package}.tar.gz \
    && rm -f ${node_js_package}.tar.gz

ENV PATH /usr/local/${node_js_package}/bin:$PATH

RUN curl --tlsv1 -kLO https://cache.ruby-lang.org/pub/ruby/${ruby_main_version}/${ruby_version}.tar.gz -o ${ruby_version}.tar.gz \
    && tar -xzf ${ruby_version}.tar.gz \
    && rm -f ${ruby_version}.tar.gz \
    && cd ${ruby_version} \
    && ./configure --with-destdir=/ \
    && make \
    && make install

RUN gem install bundler:${bundler_version}

RUN sed -i '/^mirrorlist/s/^/#/;/^#baseurl/{s/#//;s/download/dl/;s/epel/archive\/epel/}' /etc/yum.repos.d/epel.repo

RUN yum install -y \
    libapreq2

# Install AWS CLI v2
RUN curl --tlsv1 "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf ./aws && \
    rm -f awscliv2.zip
