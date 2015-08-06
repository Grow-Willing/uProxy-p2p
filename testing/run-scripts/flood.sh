#!/bin/bash

set -e

# Prints the IP of a flood server, starting one if necessary.

if [ "$#" -ne 2 ]; then
  echo "Usage: flood.sh <size of download> <max. transfer rate>"
  echo "Examples:"
  echo "  10MB @ 500k/sec: flood.sh 10M 500k"
  echo "  1GB @ 1M/sec: flood.sh 1G 10M"
  exit 1
fi

# Build an image if none already exists.
if ! docker images | grep uproxy/flood >/dev/null; then
  docker build -t uproxy/flood ${BASH_SOURCE%/*}/../../flood
fi

# Kill the current container, if any.
# TODO: Skip this if the running container's args match.
if docker ps | grep uproxy-flood >/dev/null; then
  docker rm -f uproxy-flood > /dev/null
fi

docker run -d -p 1224:1224 --name uproxy-flood uproxy/flood "$1"M $2
docker inspect --format '{{ .NetworkSettings.IPAddress }}' uproxy-flood
