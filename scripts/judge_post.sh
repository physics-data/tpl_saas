#!/bin/bash

DN=$(dirname $(readlink -f $0))
cd $DN
cd ..

function gen_file() {
  FN=$(mktemp)
  head -c 4096 < /dev/urandom > $FN
  echo $FN
}

function copyfile() {
  mkdir -p ./failed
  cp $1 ./failed
  echo $(basename $1)
}

TESTCASE=$(gen_file)
SHA=$(sha256sum $TESTCASE | cut -d' ' -f1)
TMPFILE=$(mktemp)
STATUS=$(curl --max-time 60 -s -o $TMPFILE -w "%{http_code}" -X POST --data-binary @$TESTCASE http://localhost:1080/api)

if [[ $? != 0 ]]; then
  echo "Request failed"
  exit 1
fi

if [[ $STATUS != 200 ]]; then
  echo "Expecting 200, got $STATUS"
  echo "File stored at ./failed/$(copyfile $TESTCASE)"
  exit 2
fi

echo -n $SHA | diff $TMPFILE - > /dev/null

if [[ $? != 0 ]]; then
  echo "Expecting $SHA, got $(<$TMPFILE)"
  echo "File stored at ./failed/$(copyfile $TESTCASE)"
  exit 3
fi