variable "AWS_REGION" {
  type    = string
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

variable "ami" {
  type    = string
  default = "ami-03972092c42e8c0ca"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "desired_capacity" {
  description = "Capacidade desejada de instancias"
  default     = 2
}

variable "max_size" {
  description = "Quantidade maxima de instancias"
  default     = 4
}

variable "min_size" {
  description = "Quantidade minima de instancias"
  default     = 2
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

variable "subnet_private_3_cidr" {
  type    = string
  default = "172.32.64.0/20"
}

variable "subnet_private_4_cidr" {
  type    = string
  default = "172.32.80.0/20"
}