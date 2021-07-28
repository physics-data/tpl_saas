#!/bin/bash

DN=$(dirname $(readlink -f $0))
cd $DN
cd ..

function gen_string() {
  cat /dev/urandom | tr -dc "0-9a-zA-Z" | head -c 64
}

TESTCASE=$(gen_string)
SHA=$(echo -n $TESTCASE | sha256sum | cut -d' ' -f1)
TMPFILE=$(mktemp)
STATUS=$(curl --max-time 60 -s -o $TMPFILE -w "%{http_code}" http://localhost:1080/api\?content\=$TESTCASE)

if [[ $? != 0 ]]; then
  echo "Request failed"
  exit 1
fi

if [[ $STATUS != 200 ]]; then
  echo "Expecting 200, got $STATUS"
  echo "Content: $TESTCASE"
  exit 2
fi

echo -n $SHA | diff $TMPFILE - > /dev/null

if [[ $? != 0 ]]; then
  echo "Expecting $SHA, got $(<$TMPFILE)"
  echo "Content: $TESTCASE"
  exit 3
fi
