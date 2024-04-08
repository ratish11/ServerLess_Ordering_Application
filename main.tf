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

module "instances" {
  source = "./modules/module1/instances/"
  # You can provide input variables specific to module1 here
}
module "apis" {
  source = "./modules/module1/apis/"
  # You can provide input variables specific to module1 here
  public_urls = module.instances.instance_urls
}