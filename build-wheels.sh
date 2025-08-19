#! /bin/bash

docker build . --iidfile .docker-image-id

docker run --rm -v $(pwd):/workdir $(cat .docker-image-id) echo "✅ Docker image built successful."
docker run -u $(id -u):$(id -g) --rm -v $(pwd):/workdir $(cat .docker-image-id) bash /workdir/inside-build-wheels.sh
