FROM quay.io/pypa/manylinux2014_x86_64

RUN yum install -y zip openssl-devel tree && yum clean all

WORKDIR /workdir
