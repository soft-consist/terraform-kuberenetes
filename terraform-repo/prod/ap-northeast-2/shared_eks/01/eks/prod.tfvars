cluster_name    = "Shared-cluster"
cluster_version = "1.34"

desired_size = 2
max_size     = 4
min_size     = 2

node_instance_types = ["t3.small"]
allowd_cidr_blocks  = ["12.0.0.0/16"]
region              = "ap-northeast-2"
tags                = {
  Environment = "prod"
  Project     = "shared-eks"
}
env        = "prod"

bastion_assume_role_principals = [
  "arn:aws:iam::358871393576:user/Ashutosh-Bambal",
  "arn:aws:iam::358871393576:user/Kalyani-Bambal"
]