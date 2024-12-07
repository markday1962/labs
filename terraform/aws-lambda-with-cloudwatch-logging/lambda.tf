# Get aws caller identity
data "aws_caller_identity" "current" {}

# Define the Lambda function
resource "aws_lambda_function" "lambda_function" {
    function_name    = var.lambda_function_name
    role             = aws_iam_role.lambda_role.arn
    handler          = "main.handler"
    runtime          = "python3.13"
    timeout          = 60
    memory_size      = 128

    # Use the Archive data source to zip the code
    filename         = data.archive_file.lambda_code.output_path
    source_code_hash = data.archive_file.lambda_code.output_base64sha256
}

# Define the IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
    name = var.lambda_function_iam_role_name

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

# Define the Archive data source to zip the code
data "archive_file" "lambda_code" {
    type        = "zip"
    source_dir  = "function/"
    output_path = "lambda_code.zip"
}

# Create an IAM policy for S3 bucket access
resource "aws_iam_policy" "cloudwatch_policy" {
    name        = "cloudwatch-policy"
    description = "Allows create and write log streams"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": [
                "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.lambda_function_name}:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricAlarm"
            ],
            "Resource": [
                "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
            ]
        }
    ]
}
EOF
}

# Attach the IAM policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.cloudwatch_policy.arn
}
