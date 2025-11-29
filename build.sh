#!/bin/bash
source .env

LAMBDA_FILE="lambda_auto_confirm.py"
LAMBDA_ZIP="lambda_auto_confirm.zip"
if [ -f "$LAMBDA_FILE" ]; then
    echo "Tworzenie zipa dla Lambda: $LAMBDA_ZIP"
    zip -r -o "$LAMBDA_ZIP" "$LAMBDA_FILE" > /dev/null
    echo "Gotowe: $LAMBDA_ZIP"
else
    echo "Błąd: Plik $LAMBDA_FILE nie istnieje!"
    exit 1
fi

echo "Budowanie repozytorium ecr"
terraform -chdir=terraform apply -target=aws_ecr_repository.frontend_repo -target=aws_ecr_repository.backend_repo -auto-approve

echo "Pushowanie obrazów do repozytorium ecr"
./push_ecr.sh

echo "Budowanie infrastruktury"
terraform -chdir=terraform apply -auto-approve
