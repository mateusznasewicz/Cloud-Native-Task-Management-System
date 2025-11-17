#!/bin/bash
source .env

echo "Budowanie repozytorium ecr"
terraform -chdir=terraform apply -target=aws_ecr_repository.frontend_repo -target=aws_ecr_repository.backend_repo -auto-approve

echo "Pushowanie obrazów do repozytorium ecr"
./push_ecr.sh

echo "Budowanie infrastruktury"
terraform -chdir=terraform apply -auto-approve
