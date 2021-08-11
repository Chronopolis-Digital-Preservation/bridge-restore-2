#!/bin/sh

# create symlinks to ucsd preservation for duracloud restoration

if [ $# -ne 2 ]; then
  echo "usage: $0 <chronopolis src> <duracloud restorations dst>"
  exit 1
fi

SRC=$1
DST=$2

if [ ! -d $SRC ]; then
  echo "missing $SRC"
  exit 1
fi

if [ ! -d $DST ]; then
  echo "missing $DST"
  exit 1
fi

cnt=$(ls $DST | wc -l)
if [ $cnt -ne 0 ]; then
  echo "ALREADY CONTAINS LINKS $DST"
  exit 1
fi

while read path; do
  if [ ! -e $SRC/$path ]; then
    echo "missing $SRC/$path"
    continue
  fi
  echo $path
  ln -s $SRC/$path $DST
done <<HERE
.collection-snapshot.properties
manifest-md5.txt
manifest-sha256.txt
content-properties.json
data
HERE

# some content-properties.json contain Windows file paths
# unescaped backslash violates json
PWD=`pwd`
cd $DST && \
sed 's/[^\\]\\[^\\]/\\\\/g' content-properties.json > content-properties.json.$$ && \
rm -f content-properties.json && \
mv content-properties.json.$$ content-properties.json && \
cd $PWD

exit 0
