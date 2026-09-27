variable "aws_region" {
  description = "Region to deploy into"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Prefix for all resource names"
  type        = string
  default     = "gha-demo"
}