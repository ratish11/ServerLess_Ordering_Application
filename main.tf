terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

#ec2 with api-gateway
# module "instances" {
#   source = "./modules/module1/instances/"
#   # You can provide input variables specific to module1 here
# }
# module "apis" {
#   source = "./modules/module1/apis/"
#   # You can provide input variables specific to module1 here
#   public_urls = module.instances.instance_urls
# }

#To build a simple API in AWS, you can leverage AWS API Gateway, DynamoDB and AWS Lambda services.  


module "dynamodb" {
  source = "./modules/module2/dynamodb"
}

module "lambda" {
  source = "./modules/module2/lambda/"
  db_arn = module.dynamodb.db_arn
  api_arn = module.apigateway.api_arn
}

module "apigateway" {
  source            = "./modules/module2/apigateway"
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
}