variable "region" {
  type = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the VPC"
  type        = map(string)
}

variable "public_subnets" {
  description = "Public Subnets"
  type        = list(string)
}

variable "azs" {
  description = "Availabilty Zone"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private Subnets"
  type        = list(string)
}
