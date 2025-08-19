# About

This is a standard python wheel packaging OmniORB/OmniORBpy for easy use from python projects.

See original software here: https://omniorb.sourceforge.io/

# How to build

Run ```build-wheels.sh```

# Development principles

_Everything_ happens in the provided Docker images.

It is based on manylinux2014_x86_64 (from project https://github.com/pypa/manylinux) for maximum
compatibility with glibc 2.17.

Other architectures will come later. Maybe.