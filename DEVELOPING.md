# Developing jeteve-omniorb

## What this repo does

This repo builds and packages OmniORB (a CORBA ORB) and OmniORBpy (its Python bindings) as a standard PyPI wheel (`jeteve-omniorb`). The wheel bundles the compiled OmniORB binaries and shared libraries so users can install it with `pip` or `uvx` without compiling anything themselves.

Everything happens inside Docker. There is no local Python build or test workflow — all compilation and testing runs inside a `manylinux2014` container.

## Key files

- **`Dockerfile`** — Builds the builder image from `manylinux2014_<arch>`. Installs `openssl-devel` and `zip`.
- **`inside-build-wheels.sh`** — Runs inside the container. Compiles OmniORB and OmniORBpy from source tarballs in `vendor/`, assembles the Python package using `hatch`, generates `pyproject.toml` via `m4`, and runs `auditwheel repair` to produce a self-contained manylinux wheel in `wheelhouse/`.
- **`inside-test-wheels.sh`** — Runs inside the container. Installs the just-built wheel from `wheelhouse/` and exercises the packaged binaries plus the full OmniORB example (echo server/client, name server).
- **`build-wheels.sh`** — Local dev convenience script: builds the Docker image, then loops over Python versions and OmniORB versions calling the two scripts above.
- **`pyproject.toml.m4`** — M4 template for `pyproject.toml`. Substituted variables: `VERSION`, `PYTHON_VERSION`, `PYVER`, `POSTN_DOT_DEVN`, `MANYLINUX_ARCH`. The version field encodes OmniORB version + git-tag-derived `.postN` or `.postN.devN`.
- **`wrapper.py`** — Thin Python shim that delegates CLI entry-points (e.g. `omnicpp`, `omniNames`) to the bundled binaries in `jeteve_omniorb/bin/`.
- **`vendor/`** — Vendored source tarballs for OmniORB and OmniORBpy (multiple versions).
- **`example_<version>/`** — OmniORB example files used by the test script.

## Build commands

Build the Docker image and all wheels locally (x86_64 by default):
```bash
bash build-wheels.sh
```

Build just the Docker image:
```bash
docker buildx build . --iidfile .docker-image-id
```

Build a single wheel (inside the container):
```bash
docker run -t -e HOME=/workdir -u $(id -u):$(id -g) --rm -v $(pwd):/workdir $(cat .docker-image-id) \
  bash /workdir/inside-build-wheels.sh "cp312" "4.3.3"
```

Test a single wheel (inside the container):
```bash
docker run -t -e HOME=/workdir -u $(id -u):$(id -g) --rm -v $(pwd):/workdir $(cat .docker-image-id) \
  bash /workdir/inside-test-wheels.sh "3.12" "4.3.3"
```

## Versioning

Wheel versions follow `<omniorb_version>.<postN>[.devN]` (PEP 440). The `.postN` and `.devN` parts come from `git describe --tags`. Tag the repo with `.postN` suffixes (e.g. `post1`, `post2`).

## Releasing

1. `uvx twine check wheelhouse/*`
2. `uvx twine upload --repository testpypi wheelhouse/*`
3. Verify with `uvx -n -p 3.12 --from "jeteve_omniorb~=4.3.3" --index-url https://test.pypi.org/simple/ omnicpp -h`
4. `uvx twine upload wheelhouse/*` (production PyPI)

## CI

GitHub Actions (`.github/workflows/main.yml`) runs on every push. It builds and tests a matrix of Python versions (3.8–3.14) × OmniORB versions × architectures (x86_64, aarch64) using native GitHub runners. Wheels are saved as artifacts and merged into a single `wheelhouse` artifact by the `gather-wheels` job.
