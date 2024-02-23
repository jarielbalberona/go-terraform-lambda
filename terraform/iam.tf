# Create an IAM role for the Lambda function
resource "aws_iam_role" "datalake_lambda_role" {
  name = "${var.project}-lambda-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# Attach policies to the IAM role
resource "aws_iam_role_policy_attachment" "datalake_lambda_execution" {
  role       = aws_iam_role.datalake_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_user_policy" "datalake_events_policy" {
  name       = "CloudWatchEventsPutRulePolicy"
  user       = "jariel"
  policy     = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        "Action": "*",
        Resource = "arn:aws:events:ap-southeast-1:486564619398:rule/silk-datalake-lambda-function-daily-trigger"
      }
    ]
  })
}

resource "aws_iam_policy" "datalake_lambda_s3_policy" {
  name        = "LambdaS3Policy"
  description = "Allows Lambda function to upload files to S3"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": "arn:aws:s3:::silk-datalake/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "datalake_lambda_s3_policy_attachment" {
  role       = aws_iam_role.datalake_lambda_role.name
  policy_arn = aws_iam_policy.datalake_lambda_s3_policy.arn
}
