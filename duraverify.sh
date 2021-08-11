#!/bin/bash

prog=`basename $0`

tmp=/tmp/$prog.$$
tmp2=/tmp/$prog-tmp2.$$
comm3=/tmp/$prog-comm3.$$

trap "rm -f $tmp $tmp2 $comm3" EXIT

if [ $# -ne 1 ]; then
  echo "usage: $0 <src>"
  exit 1
fi
src=$1

if [ ! -d $src ]; then
  echo "MISSING SRC $src"
  exit 1
fi

contentproperties=$src/content-properties.json

if [ ! -f $contentproperties ]; then
  echo "MISSING CONTENT-PROPERTIES $contentproperties"
  exit 1
fi

data=$src/data

if [ ! -d $data ]; then
  echo "MISSING DATA $data"
  exit 1
fi


# some content-properties.json contain Windows file paths
# convert backslash to slash
sed 's/\\/\\\\/g' $contentproperties |\
jq -jr '.[] | keys[] as $k | .[$k]."content-checksum", " ", $k, "\n"' |\
sort > $tmp

if [ $? -ne 0 ]; then
  echo "JQ FAIL $contentproperties"
  exit 1
fi

find $contentproperties $data -type f -print |\
xargs md5sum |\
sed 's; .*/; ;' |\
sort > $tmp2

comm -3 $tmp2 $tmp2 > $comm3
if [ -s $comm3 ]; then
  echo "CHECKSUM FAIL $src"
  cat $comm3
  exit 1
fi

exit 0
