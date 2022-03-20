#!/bin/bash

export COMPOSE_PROJECT_NAME=dockeruccio
export DOCKER_BUILDKIT=1
export DOCKER_SCAN_SUGGEST=false

docker-compose build
docker-compose up -d
