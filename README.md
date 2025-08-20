# About

This is a standard python wheel packaging OmniORB/OmniORBpy for easy use from python projects.

See original software here: https://omniorb.sourceforge.io/

## Batteries included

We aim at supporting the full Python example from omniorb out of the box:

https://omniorb.sourceforge.io/omnipy43/omniORBpy/omniORBpy002.html#sec10

In particular, that means that this packages the binary `omnicpp` (OmniORBs take on a C Preprocessor) coming from the C/C++ OmniORB library.



# How to build

Run ```build-wheels.sh``` You only need docker

# Version management

For now this is manual.

This would produce 

# Development principles

_Everything_ happens in the provided Docker images.

It is based on manylinux2014_x86_64 (from project https://github.com/pypa/manylinux) for maximum
compatibility with glibc 2.17.

Other architectures will come later. Maybe.

# How to upload

1) Check all wheels with twine (using uvx is recommended)

uvx twine check wheelhouse/*

2) Upload to test repo

uvx twine upload --repository testpypi wheelhouse/*

3) Check you can download and execute
uvx --from jeteve_omniorb==4.3.3.post1  --index-url https://test.pypi.org/simple/ omniidl -u