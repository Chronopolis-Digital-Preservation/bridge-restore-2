#!/bin/sh

# inform bridge app that chronopolis bag is staged for restoration

prog=`basename $0`
dir=`dirname $0`

vars=$dir/restorevars
if [ ! -x $vars ]; then
  echo "MISSING VARS $vars"
  exit 1
fi
. $vars

if [ $# -ne 1 ]; then
  echo "MISSING RESTORE ID"
  exit 1
fi
restoreid=$1

curl -u $USER:$PASS -X POST https://$BRIDGE/bridge/restore/$restoreid/complete

exit 0
