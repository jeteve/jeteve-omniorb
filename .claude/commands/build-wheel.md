Ask the user two multiple-choice questions:

1. Which Python version to build for?
   - cp310
   - cp311
   - cp312
   - cp313
   - cp314
   - cp315

2. Which OmniORB version to package?
   - 4.2.6
   - 4.3.2
   - 4.3.3

Then run the following steps using those choices (PYABI = the cp* selection, OMNIORB_VERSION = the version selection):

1. Build the Docker builder image (if .docker-image-id does not already exist or the user wants a fresh build):
```
docker buildx build . --iidfile .docker-image-id
```

2. Build the wheel inside the container:
```
docker run -t -e HOME=/workdir -u $(id -u):$(id -g) --rm -v $(pwd):/workdir $(cat .docker-image-id) bash /workdir/inside-build-wheels.sh "$PYABI" "$OMNIORB_VERSION"
```

3. Test the wheel inside the container (PYTHON_VERSION = PYABI without the "cp" prefix and with a dot, e.g. cp312 → 3.12):
```
docker run -t -e HOME=/workdir -u $(id -u):$(id -g) --rm -v $(pwd):/workdir $(cat .docker-image-id) bash /workdir/inside-test-wheels.sh "$PYTHON_VERSION" "$OMNIORB_VERSION"
```

Report the path of the resulting wheel from the `wheelhouse/` directory when done.
