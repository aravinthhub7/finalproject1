#!/bin/bash
set -euo pipefail

EC2_USER="ec2-user"
EC2_HOST="100.26.138.166"
IMAGE_REMOTE="aravinthdevops/dev-repo:latest"
KEY_FILE=${1:-}

if [ -z "$KEY_FILE" ]; then
    echo "Usage: ./deploy.sh <key-file>"
    echo "Example: ./deploy.sh ~/.ssh/mykey.pem"
    exit 1
fi

PASS=${DOCKERHUB_PASS:-}
if [ -z "$PASS" ]; then
    echo "❌ ERROR: Set DOCKERHUB_PASS environment variable."
    exit 1
fi

echo "🚀 Deploying $IMAGE_REMOTE to $EC2_HOST..."

ssh -i "$KEY_FILE" -o StrictHostKeyChecking=no "$EC2_USER@$EC2_HOST" bash <<EOF
    set -e
    echo "🔑 Logging into Docker Hub..."
    echo "$PASS" | docker login -u "aravinthdevops" --password-stdin

    echo "📥 Pulling latest image..."
    docker pull "$IMAGE_REMOTE"

    echo "🛑 Stopping old container (if exists)..."
    docker rm -f app-container || true

    echo "▶️ Running new container..."
    docker run -d --name app-container -p 80:80 "$IMAGE_REMOTE"

    echo "✅ Deployment complete!"
EOF
