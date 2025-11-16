#!/bin/bash
source .env
FRONTEND_IMAGE="frontend-build"
BACKEND_IMAGE="backend-build"
FRONTEND_DOCKERFILE="Dockerfile.frontend"
BACKEND_DOCKERFILE="Dockerfile.backend"
IMAGE_TAG=$(date +%Y%m%d%H%M%S)

FRONTEND_TAGGED_IMAGE="${TV_VAR_ecr_url_frontend}:${IMAGE_TAG}"
BACKEND_TAGGED_IMAGE="${TV_VAR_ecr_url_backend}:${IMAGE_TAG}"

# Building docker images
docker build -f $FRONTEND_DOCKERFILE -t $FRONTEND_IMAGE .
docker build -f $BACKEND_DOCKERFILE -t $BACKEND_IMAGE .

# ECR
aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin $ECR_URL
docker tag $FRONTEND_IMAGE $FRONTEND_TAGGED_IMAGE
docker tag $BACKEND_IMAGE $BACKEND_TAGGED_IMAGE
docker push $FRONTEND_TAGGED_IMAGE
docker push $BACKEND_TAGGED_IMAGE
docker rmi $FRONTEND_IMAGE $FRONTEND_TAGGED_IMAGE
docker rmi $BACKEND_IMAGE $BACKEND_TAGGED_IMAGE