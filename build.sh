#!/usr/bin/env bash
set -euo pipefail

# Usage: DOCKERHUB_USER=xxx DOCKERHUB_PASS=yyy ./build.sh dev-repo
REPO=${1:-dev-repo}
USER=${DOCKERHUB_USER:-}
PASS=${DOCKERHUB_PASS:-}
if [ -z "$USER" ] || [ -z "$PASS" ]; then
  echo "Set DOCKERHUB_USER and DOCKERHUB_PASS env vars"
  exit 1
fi

TAG=$(git rev-parse --short HEAD || echo "local")
IMAGE="${USER}/${REPO}:${TAG}"
LATEST="${USER}/${REPO}:latest"

echo "Building $IMAGE ..."
docker build -t "${IMAGE}" .
docker tag "${IMAGE}" "${LATEST}"

echo "$PASS" | docker login -u "$USER" --password-stdin
docker push "${IMAGE}"
docker push "${LATEST}"
echo "Pushed: ${IMAGE} and ${LATEST}"
