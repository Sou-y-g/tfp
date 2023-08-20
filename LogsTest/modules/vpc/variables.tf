variable "region" {
  description = "The region for VPC"
  type        = string
  default = "ap-northeast-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "The AZ for the subnet"
  type        = string
  default     = "ap-northeast-1a"
}

variable "my_ip" {
  description = "Your IP address for security group rules."
}