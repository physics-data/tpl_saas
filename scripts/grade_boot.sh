#!/bin/bash

SCRIPT_PATH=$(readlink -f "${BASH_SOURCE[0]}")
DN="$(dirname "$SCRIPT_PATH")"
cd "${DN}/../"

./saas.sh >./server_output 2>&1 &
SERVER_PID=$!

echo "Sleeping 5 secs to wait for the server"
sleep 5

./scripts/grade.sh
EXIT_CODE=$?

echo "Shuting down server..."
kill -9 $SERVER_PID

exit $EXIT_CODE
