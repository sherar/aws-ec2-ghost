variable "aws_region" {
  description = "AWS region to host the infrastructure"
  type        = string
  default     = "eu-west-1"
}

variable "ec2_instance_type" {
  description = "AWS instance type"
  type        = string
  default     = "t2.micro"
}

variable "ec2_keypair" {
  type        = string
  description = "Your public key for SSH connectivity to EC2 ghost box (e.g. sha-rsa...):"
  default     = "sha-rsa YourKey"
}

variable "db_pass" {
  type        = string
  sensitive   = true
  description = "Set a new password for the root database user. Note: Ghost will temporarily use these credentials to create its database and own user account to use going forward:"
  default     = ""
}
variable "db_name" {
  type        = string
  description = "Name of the new database that Ghost will use:"
  default     = "website_prod"
}