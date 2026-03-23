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

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "my-terraform-state-ashu-abc-xyz"
    key    = "prod-terraform.tfstate"   # must match the VPC backend key
    region = "ap-northeast-2"
  }
}

data "terraform_remote_state" "bastion" {
  backend = "s3"
  config = {
    bucket = "my-terraform-state-ashu-abc-xyz"
    key    = "prod-terraform.tfstate"   # if you have a bastion module separately
    region = "ap-northeast-2"
  }
}

module "eks" {
  source                  = "git::https://github.com/soft-consist/terraform-modules.git//modules/eks?ref=v9.0.27"
  env                     = var.env
  cluster_name            = var.cluster_name
  cluster_version         = var.cluster_version
  vpc_id                  = data.terraform_remote_state.vpc.outputs.aws_vpc
  private_subnet_ids      = data.terraform_remote_state.vpc.outputs.private_subnet_ids  
  tags                    = var.tags
  desired_size            = var.desired_size
  max_size                = var.max_size
  min_size                = var.min_size
  node_instance_types     = var.node_instance_types
  allowd_cidr_blocks      = var.allowd_cidr_blocks
  bastion_access_role_arn = data.terraform_remote_state.bastion.outputs.bastion_access_role_arn
}

module "bastion" {
  source                         = "git::https://github.com/soft-consist/terraform-modules.git//modules/bastion?ref=v9.0.27"
  env                            = var.env
  tags                           = var.tags
  bastion_assume_role_principals = var.bastion_assume_role_principals
}