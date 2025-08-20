# !/usr/bin/env bash

PYVER=$1
OMNIORB_VERSION=$2

set -e

echo "Building OmniORB $OMNIORB_VERSION and wheels for Python $PYVER"
id

export HOME=/workdir

echo "Available Pythons:"
ls /opt/python/


OMNIORB_DESTDIR=/workdir/dist/${PYVER}/omniORB-${OMNIORB_VERSION}
curl -L https://downloads.sourceforge.net/omniorb/omniORB-${OMNIORB_VERSION}.tar.bz2 | tar xj
cd omniORB-${OMNIORB_VERSION}

PYTHON=/opt/python/${PYVER}-${PYVER}/bin/python ./configure --with-openssl=/usr
make -j
mkdir -p ${OMNIORB_DESTDIR}
make install DESTDIR=${OMNIORB_DESTDIR}

echo "✅ omniORB installed at ${OMNIORB_DESTDIR}"
cd ..

echo "Now building omniORBpy"
curl -L https://downloads.sourceforge.net/omniorb/omniORBpy/omniORBpy-${OMNIORB_VERSION}/omniORBpy-${OMNIORB_VERSION}.tar.bz2 | tar xj
cd omniORBpy-${OMNIORB_VERSION}

export PYTHON=/opt/python/${PYVER}-${PYVER}/bin/python

./configure --with-omniorb=${OMNIORB_DESTDIR}/usr/local
make -j
make install DESTDIR=${OMNIORB_DESTDIR}
echo "✅ omniORBpy installed at ${OMNIORB_DESTDIR}"
cd ..

PYTHON_VERSION=$($PYTHON -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
SITE_PACKAGES=${OMNIORB_DESTDIR}/usr/local/lib/python${PYTHON_VERSION}/site-packages

if [ ! -d "${SITE_PACKAGES}" ]; then
    echo "❌ Error: site-packages directory not found at ${SITE_PACKAGES}"
    exit 1
fi

echo "✅ Found site-packages at ${SITE_PACKAGES}"
echo "Now building wheels"

# Package wheel
rm -rf jeteve-omniorb
uvx hatch new "Jeteve OmniORB"

m4 -D VERSION=${OMNIORB_VERSION}\
 -D PYTHON_VERSION=${PYTHON_VERSION}\
 -D PYVER=${PYVER}\
 pyproject.toml.m4 > jeteve-omniorb/pyproject.toml

cp -f setup.py jeteve-omniorb/
rm jeteve-omniorb/src/jeteve_omniorb/__about__.py

cd jeteve-omniorb

cp -rvf ${SITE_PACKAGES}/* src/

${PYTHON} -m build --wheel

LAST_WHEEL=$(ls dist/*.whl | tail -n 1)

auditwheel show ${LAST_WHEEL}
LD_LIBRARY_PATH=${OMNIORB_DESTDIR}/usr/local/lib/:$LD_LIBRARY_PATH auditwheel repair ${LAST_WHEEL} -w ../wheelhouse/

LAST_WHEELHOUSE=$(ls ../wheelhouse/*.whl | tail -n 1)
auditwheel show ${LAST_WHEELHOUSE}
echo "✅ Wheel built successfully: ${LAST_WHEELHOUSE}"
cd ..
