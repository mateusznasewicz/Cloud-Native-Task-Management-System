export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=
export AWS_ACCOUNT_ID=
export AWS_REGION=

ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
export TF_VAR_app_name=to-do-app
export TF_VAR_frontend_repo=${TF_VAR_app_name}/frontend
export TF_VAR_backend_repo=${TF_VAR_app_name}/backend
export TF_VAR_aws_region=$AWS_REGION
export TF_VAR_ecr_url_frontend=${ECR_URL}/${TF_VAR_frontend_repo}
export TF_VAR_ecr_url_backend=${ECR_URL}/${TF_VAR_backend_repo}

export TF_VAR_frontend_port=80
export TF_VAR_backend_port=8080
export TF_VAR_db_port=5432

export TF_VAR_db_name=
export TF_VAR_db_user=
export TF_VAR_db_password=