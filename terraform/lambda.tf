resource "aws_lambda_function" "auto_confirm" {
  filename         = "../lambda_auto_confirm.zip"
  function_name    = "AutoConfirmUserLambda"
  role             = data.aws_iam_role.aws_lab_role.arn
  handler          = "lambda_auto_confirm.lambda_handler"
  runtime          = "python3.9"

  source_code_hash = filebase64sha256("../lambda_auto_confirm.zip")
}

resource "aws_lambda_permission" "allow_cognito" {
  statement_id  = "AllowCognitoInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auto_confirm.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.app_user_pool.arn
}