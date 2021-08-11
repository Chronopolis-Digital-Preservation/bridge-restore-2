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
inform=$dir/inform.sh
if [ ! -x $inform ]; then
  echo "MISSING INFORM $inform"
  exit 1
fi
duraverify=$dir/duraverify.sh
if [ ! -x $duraverify ]; then
  echo "MISSING DURAVERIFY $duraverify"
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

# get RETRIEVING_FROM_STORAGE from DB
echo "select status,space_id,store_id,restoration_id from restoration where status=\"$STATUS\";" |\
mysql -N -h $DBHOST -u $DBUSER $DBNAME --password=$DBPASS > $tmp

if [ ! -s $tmp ]; then
  echo "NOTHING TO DO"
  exit 0
fi

while read status space_id store_id restoration_id; do

  dst=$RESTORATIONS/$restoration_id
  if [ ! -d $dst ]; then
    echo "MISSING RESTORATION DST $dst"
    continue
  fi

  depositor=$(echo $restoration_id | cut -d _ -f1)

  src=$CHRONOPOLIS/$depositor
  if [ ! -d $src ]; then
    echo "NO DEPOSITOR $src"
    continue
  fi

  # for some reason, space_id in db has - where chronopolis has _
  # convert - to _ just before date
  arf=$(echo ${space_id} | sed 's/\(.*\)-\([0-9]*-[0-9]*-[0-9]*-[0-9]*-[0-9]*-[0-9]*\)$/\1_\2/')

  src=$CHRONOPOLIS/$depositor/${depositor}_${store_id}_${arf}
  if [ ! -d $src ]; then
    echo "NO RESTORATION SRC $src"
    continue
  fi

  echo $src
  echo $dst

  $duraverify $src
  if [ $? -ne 0 ]; then
    echo "DURAVERIFY FAIL $src"
    continue
  fi

#  echo "$link $src $dst"
#  $link $src $dst
#  if [ $? -ne 0 ]; then
#    echo "LINK FAIL"
#    continue
#  fi

#  echo "$inform $restoration_id"
#  $inform $restoration_id
#  if [ $? -ne 0 ]; then
#    echo "INFORM FAIL"
#    continue
#  fi
  
done < $tmp

exit 0
