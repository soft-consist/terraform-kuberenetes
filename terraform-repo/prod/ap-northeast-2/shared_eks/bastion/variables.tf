variable "region" {
  type = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "bastion_assume_role_principals" {
  description = "List of IAM principals (users or roles) that can assume the bastion access role"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to the bastion resources"
  type        = map(string)
}