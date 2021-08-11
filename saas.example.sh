#!/bin/bash

echo "Sample SHA256 calculation" | sha256sum

echo "--------"
echo "Try: curl -I http://localhost:1080"
echo "Also try: wget http://localhost:1080"
echo "To test, use: curl -X POST --data 'string_here' http://localhost:1080/api"
echo "Use Ctrl-C to terminate the server"
echo "--------"

function accept {
  #
  # TODO: change to SHA256 as a Service server implementation
  #
  read -r request_line
  >&2 echo "Got request, first line: $request_line"

  echo -e "HTTP/1.1 404 Not Found\r\n\r" 
}

while true; do

  # Warning for Mac / Windows users:
  # The `-N` option for netcat is used to terminate connections on EOF.
  # It may have other names on your distro / OS's netcat implementation (especially if you are a mac user)
  # Check `man nc` for detail.
  FIFONAME=$(mktemp -u)
  mkfifo $FIFONAME

  # Named pipe loop
  nc -N -l 1080 < $FIFONAME | accept > $FIFONAME

  rm $FIFONAME
done
