# !/usr/bin/env bash

echo "Building OmniORB and wheels as.."
id

echo "Available Pythons:"
ls /opt/python/


OMNIORB_VERSION=4.3.3
PYVER=cp313

OMNIORB_DESTDIR=/workdir/dist/${PYVER}/omniORB-${OMNIORB_VERSION}
#curl -L https://downloads.sourceforge.net/omniorb/omniORB-${OMNIORB_VERSION}.tar.bz2 | tar xj
#cd omniORB-${OMNIORB_VERSION}

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