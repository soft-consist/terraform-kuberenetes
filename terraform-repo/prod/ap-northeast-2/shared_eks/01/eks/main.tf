terraform {
  backend "s3" {
    bucket         = "my-terraform-state-ashu-abc-xyz"
    key            = "prod-terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "prod-terraform-locks-abc"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source          = "git::https://github.com/soft-consist/terraform-modules.git//modules/vpc?ref=v9.0.27"
}

module "eks" {
  source                  = "git::https://github.com/soft-consist/terraform-modules.git//modules/eks?ref=v9.0.27"
  env                     = var.env
  cluster_name            = var.cluster_name
  cluster_version         = var.cluster_version
  vpc_id                  = module.vpc.aws_vpc
  private_subnet_ids      = module.vpc.private_subnet_ids
  tags                    = var.tags
  desired_size            = var.desired_size
  max_size                = var.max_size
  min_size                = var.min_size
  node_instance_types     = var.node_instance_types
  allowd_cidr_blocks      = var.allowd_cidr_blocks
  bastion_access_role_arn = module.bastion.bastion_access_role_arn
}

output "aws_vpc" {
  value = module.vpc.aws_vpc
}

output "public_subnet_ids" {
   value = module.vpc.public_subnet_ids
 }

output "bastion_access_role_arn" {
   value = module.bastion.bastion_access_role_arn
 }