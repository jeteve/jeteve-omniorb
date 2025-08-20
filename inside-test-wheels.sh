PYTHON_VERSION=3.13

set -xe

uv venv -p $PYTHON_VERSION --clear
source .venv/bin/activate
uv pip install -n --no-index --find-links=wheelhouse/ "jeteve_omniorb>=4.3.3.post1"

cd example
echo "✅ Omnicpp works" | omnicpp

omniNames --help > /dev/null
echo "✅ omniNames works"

# Follow the example from https://omniorb.sourceforge.io/omnipy43/omniORBpy/omniORBpy002.html#sec10
omniidl -bpython example_echo.idl

echo "Running example1"
python example1.py

echo "Running example2 server"
python example2-server.py &
server_pid=$!
sleep 2

echo "Running example2 client"
python example2-client.py < /tmp/example2_ref.${server_pid}.txt

kill $server_pid  $(ps -s $server_pid -o pid=)
wait

echo "Running with a name server"
omniNames_dir=/tmp/omniNames$$
mkdir -p $omniNames_dir
omniNames -start 12345 -datadir $omniNames_dir &
omniNames_pid=$!
sleep 2

orb_params="-ORBInitRef NameService=corbaloc:iiop:1.2@localhost:12345/NameService -ORBclientCallTimeOutPeriod 3000 -ORBclientConnectTimeOutPeriod 3000"

python example3-server.py $orb_params &
server3_pid=$!
sleep 2
kill $server3_pid $(ps -s $server3_pid -o pid=)


kill $omniNames_pid $(ps -s $omniNames_pid -o pid=)
wait

killall omniNames