from setuptools import setup
from setuptools.dist import Distribution

from pathlib import Path

# This will force the wheels to be platform and Python ABI specific.

class BinaryDistribution(Distribution):
    """Force platform-specific wheel"""
    def has_ext_modules(self):
        return True

# Auto-discover All top level .py files in src/
src_files = [f.stem for f in Path("src").glob("*.py") 
             if not f.name.startswith("_")]


setup(
    distclass=BinaryDistribution,
    py_modules=src_files,
    )