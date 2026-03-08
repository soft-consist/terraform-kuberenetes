env        = "prod"
cidr_block = "12.0.0.0/16"
tags = {
  "name" = "prod-1"
}
azs             = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
public_subnets  = ["12.0.1.0/24", "12.0.2.0/24", "12.0.3.0/24"]
private_subnets = ["12.0.11.0/24", "12.0.12.0/24", "12.0.13.0/24"]
region          = "ap-northeast-2"