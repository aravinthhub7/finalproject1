#!/usr/bin/env bash
set -euo pipefail

# Usage: ./deploy.sh ec2-user ec2-ip docker-image /path/to/key.pem
EC2_USER=${1:?}
EC2_HOST=${2:?}
IMAGE=${3:?}          # e.g. youruser/dev-repo:latest
KEY=${4:-~/.ssh/id_rsa}

echo "Deploying $IMAGE to $EC2_USER@$EC2_HOST ..."

ssh -o StrictHostKeyChecking=no -i "$KEY" "$EC2_USER@$EC2_HOST" bash -s <<EOF
set -e
docker pull $IMAGE
docker rm -f myapp || true
docker run -d --name myapp -p 80:80 --restart always $IMAGE
EOF

echo "Deployment done."
