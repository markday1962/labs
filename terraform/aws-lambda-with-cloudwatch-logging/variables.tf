variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "lambda_function_name" {
  default = "BasicLambdaWithCloudwatchLogging-tf"
}

variable "lambda_function_iam_role_name" {
  default = "BasicLambdaWithCloudwatchLoggingLambdaRole"
}
