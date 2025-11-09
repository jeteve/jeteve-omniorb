# !/usr/bin/env bash

PYVER=$1
OMNIORB_VERSION=$2

set -xe

POSTN=$(git describe --tags | cut -d- -f1)
DEVN=$(git describe --tags | cut -s -d'-' -f2)

POSTN_DOT_DEVN="${POSTN}"
if [ -n "$DEVN" ]; then
    POSTN_DOT_DEVN="${POSTN}.dev${DEVN}"
fi
# According to https://packaging.python.org/en/latest/specifications/version-specifiers/#version-specifiers
echo "🎁 Packaging version will be '${OMNIORB_VERSION}.${POSTN_DOT_DEVN}'"

echo "==${OMNIORB_VERSION}.${POSTN_DOT_DEVN}" | uvx --with packaging python -c 'import packaging.specifiers as s; s.SpecifierSet(input())'

LOG="/workdir/log-${PYVER}-${OMNIORB_VERSION}.log"
PV_OPTS="-betlap -i 10"

set -xe

echo "Building OmniORB $OMNIORB_VERSION and wheels for Python $PYVER"
id

export HOME=/workdir

echo "Available Pythons:"
ls /opt/python/

export PYTHON=/opt/python/${PYVER}-${PYVER}/bin/python
echo "Using python $PYTHON"


$PYTHON -m pip install packaging


# from cp112 onwards, we need to install setuptools first
if [[ $PYVER -ge "cp112" ]]; then
    $PYTHON -m pip install setuptools
fi

OMNIORB_DESTDIR=/workdir/dist/${PYVER}/omniORB-${OMNIORB_VERSION}

rm -rf omniORB-${OMNIORB_VERSION}
echo "🛜 Downloading omniORB ${OMNIORB_VERSION}"
cat /workdir/vendor/omniORB-${OMNIORB_VERSION}.tar.bz2 | tar xj
cd omniORB-${OMNIORB_VERSION}

echo "📐 Configuring omniORB ${OMNIORB_VERSION} with Python ${PYTHON}"
PYTHON=$PYTHON ./configure --build=${MANYLINUX_ARCH}-unknown-linux-gnu --with-openssl=/usr 2>&1 | tee -a $LOG
echo "🛠️ Making omniORB ${OMNIORB_VERSION} with Python ${PYTHON}"
make -j 2>&1 | tee -a ${LOG}
echo "💾 Installing omniORB ${OMNIORB_VERSION} with Python ${PYTHON} in ${OMNIORB_DESTDIR}"
rm -rf ${OMNIORB_DESTDIR}
mkdir -p ${OMNIORB_DESTDIR}
make install DESTDIR=${OMNIORB_DESTDIR} 2>&1 | tee -a ${LOG}

echo "✅ omniORB installed at ${OMNIORB_DESTDIR}"
cd ..

rm -rf omniORBpy-${OMNIORB_VERSION} 
echo "Now building omniORBpy"
echo "🛜 Downloading omniORBpy ${OMNIORB_VERSION}"
cat /workdir/vendor/omniORBpy-${OMNIORB_VERSION}.tar.bz2 | tar xj
cd omniORBpy-${OMNIORB_VERSION}


echo "📐 Configuring omniORBpy ${OMNIORB_VERSION} with Python ${PYTHON} and omniORB ${OMNIORB_DESTDIR}" | tee -a ${LOG}
PYTHON=$PYTHON ./configure --build=${MANYLINUX_ARCH}-unknown-linux-gnu --with-omniorb=${OMNIORB_DESTDIR}/usr/local 2>&1 | tee -a  ${LOG}
echo "🛠️ Making omniORBpy ${OMNIORB_VERSION} with Python ${PYTHON}" | tee -a ${LOG}
make -j 2>&1 | tee -a ${LOG}
echo "💾 Installing omniORBpy ${OMNIORB_VERSION} with Python ${PYTHON} in ${OMNIORB_DESTDIR}" | tee -a ${LOG}
make install DESTDIR=${OMNIORB_DESTDIR} 2>&1 | tee -a ${LOG}
echo "✅ omniORBpy installed at ${OMNIORB_DESTDIR}" | tee -a ${LOG}
cd ..

PYTHON_VERSION=$($PYTHON -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
SITE_PACKAGES=${OMNIORB_DESTDIR}/usr/local/lib/python${PYTHON_VERSION}/site-packages

if [ ! -d "${SITE_PACKAGES}" ]; then
    echo "❌ Error: site-packages directory not found at ${SITE_PACKAGES}"
    exit 1
fi

echo "✅ Found site-packages at ${SITE_PACKAGES}"
echo "☸️ Now building wheels"

# Package wheel
rm -rf jeteve-omniorb
uvx hatch new "Jeteve OmniORB"

m4 -D VERSION=${OMNIORB_VERSION}\
 -D PYTHON_VERSION=${PYTHON_VERSION}\
 -D PYVER=${PYVER}\
 -D POSTN_DOT_DEVN=${POSTN_DOT_DEVN} \
 -D MANYLINUX_ARCH=${MANYLINUX_ARCH} \
 pyproject.toml.m4 > jeteve-omniorb/pyproject.toml

cp -f setup.py jeteve-omniorb/
rm jeteve-omniorb/src/jeteve_omniorb/__about__.py

cat README.md >> jeteve-omniorb/README.md

cd jeteve-omniorb
mkdir -p src/jeteve_omniorb
cp ../wrapper.py src/jeteve_omniorb/

mkdir -p src/jeteve_omniorb/bin/
cp -rvf ${OMNIORB_DESTDIR}/usr/local/bin/* src/jeteve_omniorb/bin/ 2>&1 | tee -a ${LOG}
cp -rvf ${SITE_PACKAGES}/* src/ | tee -a ${LOG}

echo "📦 Building wheel with Python ${PYTHON}" | tee -a ${LOG}
${PYTHON} -m build --wheel 2>&1 # | pv -s 250 $PV_OPTS >> $LOG

LAST_WHEEL=$(ls dist/*.whl | tail -n 1)

echo "Found wheel: ${LAST_WHEEL}" | tee -a ${LOG}

echo "🪛 Reparing wheel with auditwheel"
auditwheel show ${LAST_WHEEL}
LD_LIBRARY_PATH=${OMNIORB_DESTDIR}/usr/local/lib/:$LD_LIBRARY_PATH auditwheel repair ${LAST_WHEEL} -w ../wheelhouse/

LAST_WHEELHOUSE=$(ls -rt ../wheelhouse/*.whl | tail -n 1)
auditwheel show ${LAST_WHEELHOUSE}
echo "✅ Wheel built successfully: ${LAST_WHEELHOUSE}"
cd ..
