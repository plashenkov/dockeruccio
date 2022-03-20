#!/bin/bash

echo Please specify image version:
read version

cd ../..
npx vite build
docker build -t plashenkov/dockeruccio:$version docker/prod
