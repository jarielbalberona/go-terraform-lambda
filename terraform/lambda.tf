# Create a Lambda function
resource "aws_lambda_function" "datalake_lambda_function" {
  function_name    = "${var.project}-lambda-function"
  role             = aws_iam_role.datalake_lambda_role.arn
  handler          = "main"
  runtime          = "go1.x"
  timeout          = 10
  memory_size      = 128
  filename         = "../build/silk-datalake.zip"
  source_code_hash = filebase64sha256("../build/silk-datalake.zip")
}

# Grant the Lambda function permission to write CloudWatch Logs
resource "aws_lambda_permission" "datalake_allow_cloudwatch_logs" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.datalake_lambda_function.function_name
  principal     = "logs.amazonaws.com"
  source_arn    = "arn:aws:logs:*:*:*"
}

# Create a CloudWatch Events rule for scheduling
resource "aws_cloudwatch_event_rule" "datalake_daily_trigger" {
  name                = "${var.project}-lambda-function-daily-trigger"
  schedule_expression = "cron(0 0 * * ? *)"  # Trigger at midnight UTC
}

# Create a CloudWatch Events target to invoke the Lambda function
resource "aws_cloudwatch_event_target" "datalake_invoke_lambda" {
  rule = aws_cloudwatch_event_rule.datalake_daily_trigger.name
  arn  = aws_lambda_function.datalake_lambda_function.arn
}