#!/bin/bash

SCRIPT_PATH=$(readlink -f "${BASH_SOURCE[0]}")
DN="$(dirname "$SCRIPT_PATH")"
cd "${DN}/../"

set -e

function expect() {
  read -r RESP
  STATUS=$(echo $RESP | cut -d' ' -f2)
  if [[ $STATUS != "$1" ]]; then
    echo "Expecting status: $1"
    echo "But got status line:"
    echo $STATUS
    exit 2
  fi
}

curl --max-time 60 -s -i http://localhost:1080/abcdefg 2>&1 | expect 404
curl --max-time 60 -s -i http://localhost:1080 2>&1 | expect 404
curl --max-time 60 -s -i http://localhost:1080/apiapiapi 2>&1 | expect 404
curl --max-time 60 -s -i http://localhost:1080/api\?question_mark\=r 2>&1 | expect 404
curl --max-time 60 -s -i http://localhost:1080/api/abcdefg 2>&1 | expect 404
curl --max-time 60 -s -i http://localhost:1080/api 2>&1 | expect 405
curl --max-time 60 -s -i -X HEAD http://localhost:1080/api 2>&1 | expect 405
curl --max-time 60 -s -i -X OPTIONS http://localhost:1080/api 2>&1 | expect 405
