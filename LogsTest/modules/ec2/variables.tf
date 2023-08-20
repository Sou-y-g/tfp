variable "ami_id" {
  description = "The AMI ID for the EC2 instances"
  type        = string
  default     = "ami-01b32aa8589df6208"
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key pair name for the EC2 instances"
  type        = string
  default     = "test-key-0"
}

variable "subnet_id" {
  description = "The subnet ID for the EC2 instances"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID for the EC2 instance."
  type        = string
}