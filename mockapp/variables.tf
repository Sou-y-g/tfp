variable "region" {
  description = "The region where to deploy the infrastructure"
  type        = string
  default     = "ap-northeast-1"
}

variable "region_us" {
  description = "The region for ACM"
  type        = string
  default     = "us-east-1"
}

variable "tag" {
  description = "Prefix for the tags"
  default     = "mockapp"
}

variable "domain_name" {
  description = "Application domain name"
  default     = "cmd-karuta.xyz"
}

variable "function_file_name" {
  description = "function file name"
  type = string
  default = "hello"
}

variable "module_path" {
  description = "src path for lambda"
  type = string
  default = "module/lambda/src"
}