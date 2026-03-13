# terraform {
#   backend "s3" {
#     bucket         = "my-terraform-state-ashu-abc-xyz"
#     key            = "prod-terraform.tfstate"
#     region         = "ap-northeast-2"
#     dynamodb_table = "prod-terraform-locks-abc"
#     encrypt        = true
#   }
# }

# provider "aws" {
#   region = var.region
# }

# module "vpc" {
#   source          = "git::https://github.com/soft-consist/terraform-modules.git//modules/vpc?ref=v9.0.27"
#   env             = var.env
#   cidr_block      = var.cidr_block
#   tags            = var.tags
#   region          = var.region
#   public_subnets  = var.public_subnets
#   private_subnets = var.private_subnets
#   azs             = var.azs
# }

# output "aws_vpc" {
#   value = module.vpc.aws_vpc
# }