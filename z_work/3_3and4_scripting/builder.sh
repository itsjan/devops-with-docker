#!/bin/bash
# file builder.sh

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <github-repo> <docker-hub-repo>"
    exit 1
fi

REPO=$1
HUB_REPO=$2

TMP_DIR=$(mktemp -d)
git clone https://github.com/$REPO.git $TMP_DIR
cd $TMP_DIR
docker build -t $HUB_REPO .
docker login -u $DOCKER_USER -p $DOCKER_PWD
docker push $HUB_REPO
