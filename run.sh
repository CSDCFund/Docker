#!/bin/sh

set -o errexit
port=30399
#set -o pipefail
set -o nounset
PASSWORD=${PASSWORD:-/eswarm}
DATADIR=${DATADIR:-/config}

if [ "$PASSWORD" == "" ]; then echo "Password must be set, in order to use swarm non-interactively." && exit 1; fi

echo $PASSWORD > /password

KEYFILE=`find $DATADIR | grep UTC | head -n 1` || true
if [ ! -f "$KEYFILE" ]; then echo "No keyfile found. Generating..." && /geth --datadir $DATADIR --password /password account new; fi
KEYFILE=`find $DATADIR | grep UTC | head -n 1` || true
if [ ! -f "$KEYFILE" ]; then echo "Could not find nor generate a BZZ keyfile." && exit 1; else echo "Found keyfile $KEYFILE"; fi

VERSION=`/swarm version`
echo "Running Swarm:"
echo $VERSION

export BZZACCOUNT="`echo -n $KEYFILE | tail -c 40`" || true
if [ "$BZZACCOUNT" == "" ]; then echo "Could not parse BZZACCOUNT from keyfile." && exit 1; fi
# tc qdisc add dev eth0 root tbf rate 10mbps latency 50ms burst 2500

exec /swarm --reportinterval 5   --verbosity=3 --port $port --bzzaccount=$BZZACCOUNT  --httpaddr=0.0.0.0 --config /config/swarm.toml    --password /password --datadir $DATADIR $@ 2>>/config/out.log