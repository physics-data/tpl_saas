#!/bin/bash

DN=$(dirname $(readlink -f $0))
cd $DN
cd ..

LOG=$(mktemp)
./saas.sh >$LOG 2>&1 &
SERVER_PID=$!

./scripts/judge.sh
EXIT_CODE=$?

echo "Shuting down server..."
kill -9 $SERVER_PID
echo "Server output:"
cat $LOG

exit $EXIT_CODE
