

# About jeteve-omniorb

This is a standard python wheel packaging OmniORB/OmniORBpy for easy use from python projects.

See original software here: https://omniorb.sourceforge.io/

# Installation

This installs like a standard pypi package.

See https://pypi.org/project/jeteve-omniorb 

# Why jeteve_omniorb

- Just install a Python package, no more special OmniORB compilation on your platform.
- Packages latest stable OmniORB.
- Batteries included. Get started with OmniORB examples right after installation. See `example/` and/or https://omniorb.sourceforge.io/omnipy43/omniORBpy.
- Support for legacy glibc 2.17+ because we don't all have new shiny OSes.
- Support for python from 3.10 to 3.13.
- Latest stable OmniOrb Automatically tested using omniorb's example from https://omniorb.sourceforge.io/omnipy43/omniORBpy/ .
- Tested to work with `uvx` if you want to just run `omniidl` or `omniNames`.
- cute emojis in shell scripts.

## Batteries included

We aim at supporting the full Python example from omniorb out of the box:

https://omniorb.sourceforge.io/omnipy43/omniORBpy/omniORBpy002.html#sec10

In particular, that means that this packages the binary `omnicpp` (OmniORBs take on a C Preprocessor) coming from the C/C++ OmniORB library.

This is tested as part of the building process.

# How to build

Run ```build-wheels.sh``` You only need docker

# Version management

For now this is manual. Don't forget to update `pyproject.toml.m4`

# Development principles

_Everything_ happens in the provided Docker images.

It is based on manylinux2014_x86_64 (from project https://github.com/pypa/manylinux) for maximum
compatibility with glibc 2.17.

Other architectures will come later. Maybe.

## Dev notes - how to upload

1) Check all wheels with twine (using uvx is recommended)

uvx twine check wheelhouse/*

2) Upload to test repo

uvx twine upload --repository testpypi wheelhouse/*

3) Check you can download and execute
uvx -n -p 3.13 --from "jeteve_omniorb~=4.3.3"  --index-url https://test.pypi.org/simple/ omnicpp -h
uvx -n -p 3.12 --from "jeteve_omniorb~=4.3.3"  --index-url https://test.pypi.org/simple/ omnicpp -h
uvx -n -p 3.11 --from "jeteve_omniorb~=4.3.3"  --index-url https://test.pypi.org/simple/ omnicpp -h
uvx -n -p 3.10 --from "jeteve_omniorb~=4.3.3"  --index-url https://test.pypi.org/simple/ omnicpp -h
