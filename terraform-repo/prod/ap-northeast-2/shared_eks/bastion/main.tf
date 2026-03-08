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

module "bastion" {
  source                         = "git::https://github.com/soft-consist/terraform-modules.git//modules/bastion?ref=v9.0.27"
  env                            = var.env
  tags                           = var.tags
  bastion_assume_role_principals = var.bastion_assume_role_principals
}