cluster_name    = "Shared-cluster"
cluster_version = "1.34"

desired_size = 2
max_size     = 4
min_size     = 2

node_instance_types = ["t3.small"]
allowd_cidr_blocks  = ["12.0.0.0/16"]
region              = "ap-northeast-2"