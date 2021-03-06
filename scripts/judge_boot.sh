#!/bin/bash

list_descendants ()
{
  local children=$(ps -o pid= --ppid "$1")
  for pid in $children
  do
    list_descendants "$pid"
  done
  echo "$children"
}

# https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "${SCRIPT_DIR}/../"

LOG=$(mktemp)
./saas.sh >$LOG 2>&1 &
SERVER_PID=$!

echo "Sleeping 1 secs to wait for the server"
sleep 1

./scripts/judge.sh
EXIT_CODE=$?

echo "Shuting down server..."
kill -9 $SERVER_PID $(list_descendants $SERVER_PID)
echo "Server output:"
cat $LOG

exit $EXIT_CODE
