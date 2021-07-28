#!/bin/bash

echo "Sample SHA256 calculation" | sha256sum

# Sample use of named pipe
PIPENAME=$(mktemp -u)
mkfifo -m 600 $PIPENAME
echo "Sample SHA256 calculation" > $PIPENAME &
sha256sum < $PIPENAME
