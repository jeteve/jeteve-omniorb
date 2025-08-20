#! /bin/bash
set -e

docker build . --iidfile .docker-image-id

docker run --rm -v $(pwd):/workdir $(cat .docker-image-id) echo "✅ Docker image built successful."

#SKIP_VERSIONS="cp312_4.2.6 cp313_4.2.6"
SKIP_VERSIONS=""

for PYVER in cp312 cp313 cp310 cp311; do
    for OMNIORB_VERSION in 4.2.6 4.3.3; do
        if [[ $SKIP_VERSIONS =~ "${PYVER}_${OMNIORB_VERSION}"  ]]; then
            echo "Skipping Python $PYVER with OmniORB $OMNIORB_VERSION"
            continue
        fi
        echo "Building wheels for OmniORB ${OMNIORB_VERSION} with Python ${PYVER}"
        docker run -e HOME=/workdir -t -u $(id -u):$(id -g) --rm -v $(pwd):/workdir $(cat .docker-image-id) bash /workdir/inside-build-wheels.sh "$PYVER" "$OMNIORB_VERSION"
    done
done

OMNIORB_VERSION=4.3.3
for PYTHON_VERSION in 3.10 3.11 3.12 3.13; do
    docker run -e HOME=/workdir -u $(id -u):$(id -g) --rm -v $(pwd):/workdir $(cat .docker-image-id) bash /workdir/inside-test-wheels.sh "$PYTHON_VERSION" "$OMNIORB_VERSION"
done