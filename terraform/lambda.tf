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

resource "aws_cloudwatch_log_group" "datalake_lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.datalake_lambda_function.function_name}"
}

resource "aws_lambda_permission" "datalake_allow_cloudwatch_logs" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.datalake_lambda_function.function_name
  principal     = "logs.${data.aws_region.current.name}.amazonaws.com"
}

resource "aws_cloudwatch_event_rule" "datalake_daily_trigger" {
  name                = "${var.project}-lambda-function-daily-trigger"
  schedule_expression = "cron(0 0 * * ? *)"  # Trigger at midnight UTC

  depends_on = [
    aws_iam_user_policy.datalake_events_policy
  ]
}

resource "aws_cloudwatch_event_target" "datalake_invoke_lambda" {
  rule = aws_cloudwatch_event_rule.datalake_daily_trigger.name
  arn  = aws_lambda_function.datalake_lambda_function.arn
}