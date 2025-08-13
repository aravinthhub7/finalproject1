#!/bin/bash
set -euo pipefail

# Docker Hub username
USER="aravinthdevops"

# Docker Hub password must be set in environment variable
PASS=${DOCKERHUB_PASS:-}
if [ -z "$PASS" ]; then
  echo "❌ ERROR: Set DOCKERHUB_PASS env var"
  exit 1
fi

# Repository name from script argument
REPO=${1:-finalproject1-dev}

# Create image tags
if command -v git &> /dev/null && git rev-parse --short HEAD &> /dev/null; then
  TAG=$(git rev-parse --short HEAD)
else
  TAG="local"
fi

IMAGE="${USER}/${REPO}:${TAG}"
LATEST="${USER}/${REPO}:latest"

echo "📦 Building Docker image: $IMAGE"
docker build -t "${IMAGE}" .

echo "🔖 Tagging latest..."
docker tag "${IMAGE}" "${LATEST}"

echo "🔑 Logging in to Docker Hub..."
echo "$PASS" | docker login -u "$USER" --password-stdin

echo "🚀 Pushing images to Docker Hub..."
docker push "${IMAGE}"
docker push "${LATEST}"

echo "✅ Build and push complete!"
