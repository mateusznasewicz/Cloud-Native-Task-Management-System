#!/bin/bash
source .env
FRONTEND_IMAGE="frontend-build"
BACKEND_IMAGE="backend-build"
FRONTEND_DOCKERFILE="Dockerfile.frontend"
BACKEND_DOCKERFILE="Dockerfile.backend"

# Building docker images
docker build -f $FRONTEND_DOCKERFILE -t $FRONTEND_IMAGE .
docker build -f $BACKEND_DOCKERFILE -t $BACKEND_IMAGE .

# ECR
aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin $ECR_URL
docker tag $FRONTEND_IMAGE $TF_VAR_ecr_url_frontend
docker tag $BACKEND_IMAGE $TF_VAR_ecr_url_backend
docker push $TF_VAR_ecr_url_frontend
docker push $TF_VAR_ecr_url_backend
docker rmi $FRONTEND_IMAGE $TF_VAR_ecr_url_frontend
docker rmi $BACKEND_IMAGE $TF_VAR_ecr_url_backend