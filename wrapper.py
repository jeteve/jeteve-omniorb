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

    os.chmod(binary_path, 0o755)

    return subprocess.call([str(binary_path)] + sys.argv[1:])

def run_catior():
    return run_binary("catior")

def run_convertior():
    return run_binary("convertior")

def run_genior():
    return run_binary("genior")

def run_nameclt():
    return run_binary("nameclt")

def run_omkdepend():
    return run_binary("omkdepend")


def run_omnicpp():
    return run_binary("omnicpp")

# OmniIDL is already built in.

def run_omniMapper():
    return run_binary("omniMapper")

def run_omniNames():
    return run_binary("omniNames")

if __name__ == "__main__":
    sys.exit(run_omnicpp())
