#!/bin/bash
set -euo pipefail

IMAGE_LOCAL="mini-project-2:latest"
IMAGE_REMOTE="aravinthdevops/dev-repo:latest"

PASS=${DOCKERHUB_PASS:-}
if [ -z "$PASS" ]; then
    echo "❌ ERROR: Set DOCKERHUB_PASS environment variable."
    exit 1
fi

echo "🔑 Logging into Docker Hub..."
echo "$PASS" | docker login -u "aravinthdevops" --password-stdin

echo "🏷️ Tagging image..."
docker tag "$IMAGE_LOCAL" "$IMAGE_REMOTE"

echo "📤 Pushing image to Docker Hub..."
docker push "$IMAGE_REMOTE"

echo "✅ Build and push complete!"
