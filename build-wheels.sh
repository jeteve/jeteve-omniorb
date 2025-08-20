#! /bin/bash
set -e

docker build . --iidfile .docker-image-id

docker run --rm -v $(pwd):/workdir $(cat .docker-image-id) echo "✅ Docker image built successful."

SKIP_VERSIONS="cp312_4.2.6 cp313_4.2.6"

for PYVER in cp310 cp311 cp312 cp313; do
    for OMNIORB_VERSION in 4.2.6 4.3.3; do
        if [[ $SKIP_VERSIONS =~ "${PYVER}_${OMNIORB_VERSION}"  ]]; then
            echo "Skipping Python $PYVER with OmniORB $OMNIORB_VERSION"
            continue
        fi
        echo "Building wheels for OmniORB ${OMNIORB_VERSION} with Python ${PYVER}"
        docker run -u $(id -u):$(id -g) --rm -v $(pwd):/workdir $(cat .docker-image-id) bash /workdir/inside-build-wheels.sh "$PYVER" "$OMNIORB_VERSION"
    done
done
