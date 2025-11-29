resource "aws_cognito_user_pool" "app_user_pool" {
    name = "${var.app_name}-user-pool"
    auto_verified_attributes = []

    password_policy {
        minimum_length    = 8
        require_uppercase = true
        require_lowercase = true
        require_numbers   = true
        require_symbols   = false
    }

    mfa_configuration = "OFF"

    lambda_config {
        pre_sign_up = aws_lambda_function.auto_confirm.arn
    }
}

resource "aws_cognito_user_pool_client" "app_user_pool_client" {
    name = "${var.app_name}-user-pool-client"
    user_pool_id = aws_cognito_user_pool.app_user_pool.id
    generate_secret = false

    explicit_auth_flows = [
        "ALLOW_USER_PASSWORD_AUTH",
        "ALLOW_REFRESH_TOKEN_AUTH",
        "ALLOW_USER_SRP_AUTH"
    ]

    prevent_user_existence_errors = "ENABLED"
}
