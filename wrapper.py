# For jeteve_omniorb/wrapper.py
from pathlib import Path
import os
import subprocess
import sys


def run_binary(binary_name):
    binary_path = Path(__file__).parent / "bin" / binary_name

    if not binary_path.exists():
        print(f"Binary {binary_name} not found at {binary_path}")
        sys.exit(1)

    return subprocess.call([str(binary_path)] + sys.argv[1:])

def _create_wrapper(binary_name):
    def wrapper():
        return run_binary(binary_name)
    return wrapper

run_catior = _create_wrapper("catior")
run_convertior = _create_wrapper("convertior")
run_genior = _create_wrapper("genior")
run_nameclt = _create_wrapper("nameclt")
run_omkdepend = _create_wrapper("omkdepend")
run_omnicpp = _create_wrapper("omnicpp")
# OmniIDL is already built in.
run_omniMapper = _create_wrapper("omniMapper")
run_omniNames = _create_wrapper("omniNames")

if __name__ == "__main__":
    sys.exit(run_omnicpp())
