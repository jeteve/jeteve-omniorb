PYTHON_VERSION=$1
OMNIORB_VERSION=$2

echo "💫🐍 Testing OmniORB $OMNIORB_VERSION with Python $PYTHON_VERSION"

set -e

uv venv -p $PYTHON_VERSION --clear
source .venv/bin/activate
uv pip install -n --no-index --find-links=wheelhouse/ "jeteve_omniorb>=$OMNIORB_VERSION"

cd example
echo "✅ Omnicpp works" | omnicpp

omniNames --help > /dev/null
echo "✅ omniNames works"

# Follow the example from https://omniorb.sourceforge.io/omnipy43/omniORBpy/omniORBpy002.html#sec10
omniidl -bpython example_echo.idl

echo "Running example1"
python example1.py

echo "Running example2 server"
setsid python example2-server.py &
server_pid=$!
sleep 2

echo "Running example2 client"
python example2-client.py < /tmp/example2_ref.${server_pid}.txt

kill -TERM -$server_pid


echo "Running with a name server"
omniNames_dir=/tmp/omniNames$$
mkdir -p $omniNames_dir

setsid omniNames -start 12345 -datadir $omniNames_dir &
omniNames_pid=$!
sleep 2

orb_params="-ORBInitRef NameService=corbaloc:iiop:1.2@localhost:12345/NameService -ORBclientCallTimeOutPeriod 3000 -ORBclientConnectTimeOutPeriod 3000"

setsid python example3-server.py $orb_params &
server3_pid=$!
sleep 2


python example3-client.py $orb_params

kill -TERM -$server3_pid
kill -TERM -$omniNames_pid


echo "✅🎉 OmniORB $OMNIORB_VERSION with Python $PYTHON_VERSION Success! 🎉✅"
