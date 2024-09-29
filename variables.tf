variable "efs_mount_point" {
  type    = string
  default = "/data/test"
}

variable "private_key_location" {
  description = "Location of the private key" 
  type        = string
}

variable "key_name" {
  description = "Name of the key pair"
  type        = string
  default     = "aws_access_key"
}

variable "aws_access_key" {
  description = "AWS access key"
}

variable "aws_secret_key" {
  description = "AWS secret key"
}
