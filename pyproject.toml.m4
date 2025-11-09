[build-system]
requires = ["setuptools", "wheel"]
build-backend = "setuptools.build_meta"

[tool.setuptools]
include-package-data = true

# For py_modules, see setup.py
# py-modules

[tool.setuptools.packages.find]
where = ["src"]  # Search in src directory
include = ["*"]  # Include all packages
namespaces = false

[tool.setuptools.package-data]
# The SOs from omniorb Python and the bins from omniorb.
# These will get fixed by `auditwheel repair` (See inside-build-wheels.sh)
jeteve_omniorb = ["../*.so*" , "bin/*"]

[tool.distutils.bdist_wheel]
plat-name = "manylinux2014_MANYLINUX_ARCH"


[project]
name = "jeteve-omniorb"
# PEP 440 - PyPI compatible See https://peps.python.org/pep-0440/
# and https://packaging.python.org/en/latest/specifications/version-specifiers/#version-specifiers
version = "VERSION.POSTN_DOT_DEVN" # Comes from OmniOrb version and git tag via inside-build-wheels.sh
description = 'pypi compatible packaging for OmniORB VERSION'
readme = "README.md"
requires-python = ">=3.8"
license = {text = "MIT"}
keywords = []
authors = [
  { name = "Jerome Eteve", email = "jerome.eteve@gmail.com" },
]
classifiers = [
  "Development Status :: 4 - Beta",
  "Programming Language :: Python",
  "Programming Language :: Python :: Implementation :: CPython",
  "Topic :: Software Development :: Libraries",
  "Topic :: Software Development :: Object Brokering",
  "Topic :: Software Development :: Object Brokering :: CORBA"
]
dependencies = []

[project.scripts]
omniidl = "omniidl.main:main"
omnicpp = "jeteve_omniorb.wrapper:run_omnicpp"
omniNames = "jeteve_omniorb.wrapper:run_omniNames"

[project.urls]
Documentation = "https://github.com/jeteve/jeteve-omniorb#readme"
Issues = "https://github.com/jeteve/jeteve-omniorb/issues"
Source = "https://github.com/jeteve/jeteve-omniorb"
