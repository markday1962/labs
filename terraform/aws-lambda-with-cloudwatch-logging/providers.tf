terraform {
  required_version = "1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.6"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

# remote backend
terraform {
  backend "s3" {
    bucket         = "aistemos-terraform-state"
    key            = "BasicLambdaWithLogging-tf/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}
