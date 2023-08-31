variable "region" {
  description = "The region where to deploy the infrastructure"
  type        = string
  default     = "ap-northeast-1"
}

variable "us_region" {
  description = "The region where to deploy the infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "tag" {
  description = "Prefix for the tags"
  default     = "route53test"
}

variable "domain_name" {
  type        = string
  description = "domain name"
}

variable "az-1a" {
  description = "The availability zones1a to use"
  type        = string
  default     = "ap-northeast-1a"
}

variable "az-1c" {
  description = "The availability zones1c to use"
  type        = string
  default     = "ap-northeast-1c"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public1_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "public2_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.10.0/24"
}

variable "private1_cidr" {
  description = "The CIDR block for the private1 subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private2_cidr" {
  description = "The CIDR block for the private2 subnet"
  type        = string
  default     = "10.0.11.0/24"
}

variable "all" {
  description = "The CIDR block for all"
  type        = string
  default     = "0.0.0.0/0"
}