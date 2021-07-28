#!/bin/bash

DN=$(dirname $(readlink -f $0))
cd $DN
cd ..

set -e

function expect() {
  read -r STATUS
  echo $STATUS | grep $1 > /dev/null
  if [[ $? != 0 ]]; then
    echo "Expecting status: $1"
    echo "But got status line:"
    echo $STATUS
    exit 2
  fi
}

curl --max-time 60 -s -i http://localhost:1080/abcdefg 2>&1 | expect 404
curl --max-time 60 -s -i http://localhost:1080 2>&1 | expect 404
curl --max-time 60 -s -i http://localhost:1080/apiapiapi 2>&1 | expect 404
curl --max-time 60 -s -i http://localhost:1080/api/abcdefg 2>&1 | expect 404
curl --max-time 60 -s -i -X HEAD http://localhost:1080/api 2>&1 | expect 405
curl --max-time 60 -s -i -X OPTIONS http://localhost:1080/api 2>&1 | expect 405
curl --max-time 60 -s -i http://localhost:1080/api 2>&1 | expect 400
curl --max-time 60 -s -i http://localhost:1080/api\?random\=abc 2>&1 | expect 400
