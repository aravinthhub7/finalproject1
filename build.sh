#!/bin/bash
set -e  # Exit on error

IMAGE_NAME="aravinthdevops/prod-repo"
TAG="latest"

echo "Building Docker image..."
docker build -t $IMAGE_NAME:$TAG .

echo "Tagging image..."
docker tag $IMAGE_NAME:$TAG $IMAGE_NAME:$TAG

echo "Logging into Docker Hub..."
echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin

echo "Pushing image to Docker Hub..."
docker push $IMAGE_NAME:$TAG

echo "Build & push completed!"
