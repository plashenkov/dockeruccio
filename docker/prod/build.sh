#!/bin/bash

export DOCKER_BUILDKIT=true
export DOCKER_SCAN_SUGGEST=false

cd ../..
version=$(node -p "require('./package.json').version")
docker build -t dockeruccio/dockeruccio:$version -f docker/prod/Dockerfile .
