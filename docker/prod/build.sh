#!/bin/bash

export DOCKER_BUILDKIT=1
export DOCKER_SCAN_SUGGEST=false

cd ../..
npx vite build
version=$(node -p "require('./package.json').version")
docker build -t plashenkov/dockeruccio:$version docker/prod
