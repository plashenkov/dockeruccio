#!/bin/bash

export COMPOSE_PROJECT_NAME=dockeruccio
export DOCKER_BUILDKIT=true
export DOCKER_SCAN_SUGGEST=false

docker-compose up -d --build
