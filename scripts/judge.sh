#!/bin/bash

# Disable all proxy
http_proxy=
https_proxy=
HTTP_PROXY=
HTTPS_PROXY=

# https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "${SCRIPT_DIR}/../"


STATUS_PASS=1
SHA_PASS=1

echo "Judging misc requests..."
./scripts/judge_misc.sh
if [[ $? = 1 ]]; then
  echo "Request failed. Did you start the server?"
  echo 1 > ./judge
  exit 1
elif [[ $? = 2 ]]; then
  STATUS_PASS=0
fi
echo "Done"


echo "Judging post requests..."
for i in $(seq 1 40); do
  ./scripts/judge_post.sh

  if [[ $? = 1 ]]; then
    echo 1 > ./judge
    exit 1
  elif [[ $? = 2 ]]; then
    STATUS_PASS=0
  elif [[ $? = 3 ]]; then
    SHA_PASS=0
  fi
  echo -n "."
done
echo "Done"

if [[ $STATUS_PASS = 0 ]]; then
  echo "Status code check failed"
  echo 2 > ./judge
  exit 2
elif [[ $SHA_PASS = 0 ]]; then
  echo "Checksum failed"
  echo 3 > ./judge
  exit 3
fi

echo "All passed!"
echo 0 > ./judge
exit 0
