#!/bin/bash

prog=`basename $0`
dir=`dirname $0`

vars=$dir/restorevars
if [ ! -x $vars ]; then
  echo "MISSING VARS $vars"
  exit 1
fi
. $vars

link=$dir/link.sh
if [ ! -x $link ]; then
  echo "MISSING LINK $link"
  exit 1
fi

tmp=/tmp/$prog.$$
trap "rm -f $tmp" EXIT

if [ ! -d $RESTORATIONS ]; then
  echo "NO RESTORATIONS DIR $RESTORATIONS"
  exit 1
fi

if [ ! -d $CHRONOPOLIS ]; then
  echo "NO CHRONOPOLIS DIR $CHRONOPOLIS"
  exit 1
fi

while true; do
  echo "select status,space_id,store_id,restoration_id from restoration;" |\
  mysql -N -h $DBHOST -u $DBUSER $DBNAME --password=$DBPASS
  sleep 5
  echo ""
done

exit 0
