# See https://github.com/pypa/manylinux
ARG MANYLINUX_ARCH=x86_64
FROM quay.io/pypa/manylinux2014_${MANYLINUX_ARCH}

RUN yum install -y zip openssl-devel tree && yum clean all

WORKDIR /workdir
