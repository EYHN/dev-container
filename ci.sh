#!/usr/bin/env bash

set -e

GITHUB_PAT=${1}
GITHUB_ACTOR=${GITHUB_ACTOR}

echo ${GITHUB_PAT} | docker login ghcr.io -u $GITHUB_ACTOR --password-stdin

for module in "base" "ssh"; do
  if (! $(docker pull ghcr.io/eyhn/dev-container-${module}:latest > /dev/null)); then
    echo "Can't pull old version.";
  fi
  docker build ./${module} --tag ghcr.io/eyhn/dev-container-${module}:latest --cache-from ghcr.io/eyhn/dev-container-${module}:latest
  docker push ghcr.io/eyhn/dev-container-${module}:latest
done
