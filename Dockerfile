FROM centos:6.7

RUN yum install -y \
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

RUN yum update -y \
    ca-certificates \
    curl \
    nss

RUN curl -L http://cpanmin.us -o /bin/cpanm \
    && chmod u+x /usr/local/bin/cpanm

RUN cpanm Algorithm::Diff@1.1903 \
    Term::ANSIColor@2.02 \
    Moose@2.2013 \
    Devel::Declare@0.006022
