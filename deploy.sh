#!/bin/bash
set -e

IMAGE_NAME="aravinthdevops/prod-repo"
TAG="latest"

echo "🛠️ Pulling latest image..."
docker pull $IMAGE_NAME:$TAG

echo "🚀 Deploying with Docker Compose..."
docker-compose -f docker-compose.yml up -d
