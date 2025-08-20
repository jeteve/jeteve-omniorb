PYTHON_VERSION=3.13

set -xe

# export HOME=/workdir

uv venv -p $PYTHON_VERSION --clear
source .venv/bin/activate
uv pip install -n --no-index --find-links=wheelhouse/ "jeteve_omniorb>=4.3.3.post1"

# The follow the example from https://omniorb.sourceforge.io/omnipy43/omniORBpy/omniORBpy002.html#sec10
cd example
echo "Omnicpp works" | omnicpp
omniidl -bpython example_echo.idl

echo "Running example1"
python example1.py

echo "Running example2 server"
python example2-server.py &
server_pid=$!
sleep 2

echo "Running example2 client"
python example2-client.py < /tmp/example2_ref.${server_pid}.txt

kill -SIGKILL $server_pid

