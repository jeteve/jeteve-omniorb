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
jeteve_omniorb = ["../*.so*"]

[tool.distutils.bdist_wheel]
plat-name = "manylinux2014_x86_64"


[project]
name = "jeteve-omniorb"
version = "VERSION"
description = ''
readme = "README.md"
requires-python = "==PYTHON_VERSION"
license = "MIT"
keywords = []
authors = [
  { name = "Jerome Eteve", email = "jerome.eteve@gmail.com" },
]
classifiers = [
  "Development Status :: 4 - Beta",
  "Programming Language :: Python",
  "Programming Language :: Python :: 3.13",
  "Programming Language :: Python :: Implementation :: CPython",
]
dependencies = []

[project.urls]
Documentation = "https://github.com/jeteve/jeteve-omniorb#readme"
Issues = "https://github.com/jeteve/jeteve-omniorb/issues"
Source = "https://github.com/jeteve/jeteve-omniorb"


[tool.hatch.build.targets.sdist]
