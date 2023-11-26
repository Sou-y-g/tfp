variable "region" {
  description = "The region where to deploy the infrastructure"
  type        = string
  default     = "ap-northeast-1"
}

variable "app_name" {
	description = "app_name"
	type = string
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

variable "all" {
  description = "The CIDR block for all"
  type        = string
  default     = "0.0.0.0/0"
}

variable "key_neme" {
	description = "key_neme"
	type = string
}