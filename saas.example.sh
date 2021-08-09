#!/bin/bash

###############################################
#
#  Delete from here
#
###############################################

echo "Sample SHA256 calculation" | sha256sum

# Sample use of named pipe
PIPENAME=$(mktemp -u)
mkfifo -m 600 $PIPENAME
echo "Sample SHA256 calculation" > $PIPENAME &
sha256sum < $PIPENAME

echo "--------"
echo "Try: curl http://localhost:1080"
echo "Use Ctrl-C to terminate the server"
echo "--------"

###############################################
#
#  Delete until here
#
###############################################

while true; do

  # Warning for Mac / Windows users:
  # The `-N` option for netcat is used to terminate connections on EOF.
  # It may have other names on your distro / OS's netcat implementation (especially if you are a mac user)
  # Check `man nc` for detail.
  #
  # TODO: change to SHA256 as a Service server implementation
  echo -e "HTTP/1.1 404 Not Found\r\n\r" | nc -N -l 1080
  echo "--------"
done
