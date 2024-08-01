variable "AWS_REGION" {
  type = string
  default = "us-east-1"
}

variable "az1" {
  type    = string
  default = "us-east-1a"
}

variable "az2" {
  type    = string
  default = "us-east-1b"
}

variable "vpc_cidr_block" {
  type    = string
  default = "172.32.0.0/16"
}

variable "subnet_public_1_cidr" {
  type    = string
  default = "172.32.0.0/20"
}

variable "subnet_public_2_cidr" {
  type    = string
  default = "172.32.16.0/20"
}

variable "subnet_private_1_cidr" {
  type    = string
  default = "172.32.32.0/20"
}

variable "subnet_private_2_cidr" {
  type    = string
  default = "172.32.48.0/20"
}