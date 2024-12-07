variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "lambda_function_name" {
  default = "S3TriggerFunction-tf"
}

variable "lambda_function_iam_role_name" {
  default = "S3TriggerFunctionLambdaRole"
}

variable "s3_bucket_name" {
  default = "markday-s3-trigger-function-bucket"
}

variable "s3_prefix" {
  default = "incoming"
}
