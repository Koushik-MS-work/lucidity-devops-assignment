#!/usr/bin/env bash
#
# End-to-end deploy helper: builds the Docker image, pushes it to ECR, and
# deploys the Helm chart to the EKS cluster created by Terraform.
#
# Prerequisites: aws cli (configured), docker, helm, kubectl, and a cluster
# already created via `terraform apply` in ./terraform.
#
# Usage: ./scripts/deploy.sh

set -euo pipefail

AWS_REGION="${AWS_REGION:-ap-south-1}"
ECR_REPOSITORY="${ECR_REPOSITORY:-lucidity-hello-world}"
CLUSTER_NAME="${CLUSTER_NAME:-lucidity-hello-world-eks}"
IMAGE_TAG="${IMAGE_TAG:-$(git rev-parse --short HEAD 2>/dev/null || echo latest)}"

echo "==> Fetching AWS account ID"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "==> Ensuring ECR repository exists"
aws ecr describe-repositories --repository-names "$ECR_REPOSITORY" --region "$AWS_REGION" >/dev/null 2>&1 \
  || aws ecr create-repository --repository-name "$ECR_REPOSITORY" --region "$AWS_REGION"

echo "==> Logging in to ECR"
aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$ECR_REGISTRY"

echo "==> Building and pushing Docker image"
docker build -t "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}" -t "${ECR_REGISTRY}/${ECR_REPOSITORY}:latest" ./app
docker push "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
docker push "${ECR_REGISTRY}/${ECR_REPOSITORY}:latest"

echo "==> Updating kubeconfig"
aws eks update-kubeconfig --region "$AWS_REGION" --name "$CLUSTER_NAME"

echo "==> Deploying with Helm"
helm upgrade --install hello-world ./helm/hello-world \
  --namespace default \
  --set image.repository="${ECR_REGISTRY}/${ECR_REPOSITORY}" \
  --set image.tag="${IMAGE_TAG}" \
  --wait --timeout 5m

echo "==> Rollout status"
kubectl rollout status deployment/hello-world --timeout=120s

echo "==> Done. Try:"
echo "    kubectl port-forward svc/hello-world 8080:80"
echo "    curl http://localhost:8080/"
