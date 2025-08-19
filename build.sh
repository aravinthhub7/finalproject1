#!/bin/bash
set -e

echo "Building Docker image..."

if [ -z "$DOCKERHUB_USER" ] || [ -z "$DOCKERHUB_PASS" ]; then
  echo "ERROR: Docker Hub credentials not provided."
  exit 1
fi

# Login to Docker Hub
echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin

# Build image depending on branch
if [ "$BRANCH_NAME" = "dev" ]; then
    IMAGE_TAG="dev:latest"
elif [ "$BRANCH_NAME" = "master" ]; then
    IMAGE_TAG="prod:latest"
else
    IMAGE_TAG="test:latest"
fi

docker build -t $DOCKERHUB_USER/finalproject1:$IMAGE_TAG .

echo "Image built: $DOCKERHUB_USER/finalproject1:$IMAGE_TAG"
