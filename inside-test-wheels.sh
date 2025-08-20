PYTHON_VERSION=3.13

set -xe

export HOME=/workdir

uv venv -p $PYTHON_VERSION --clear
source .venv/bin/activate
uv pip install -n --no-index --find-links=wheelhouse/ "jeteve_omniorb>=4.3.3.post1"

# The follow the example from https://omniorb.sourceforge.io/omnipy43/omniORBpy/omniORBpy002.html#sec10
cd example
echo "BLA" | omnicpp
omniidl -bpython example_echo.idl


