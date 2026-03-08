env        = "prod"
tags = {
  Environment = "prod"
  Project     = "shared-eks"
}
bastion_assume_role_principals = [
  "arn:aws:iam::358871393576:user/Ashutosh-Bambal",
  "arn:aws:iam::358871393576:user/Kalyani-Bambal"
]