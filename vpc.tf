resource "aws_vpc" "flex360-vpc" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"

}

resource "aws_subnet" "subnet-public-1" {
  vpc_id = aws_vpc.flex360-vpc.id
  cidr_block = var.subnet_public_1_cidr
  map_public_ip_on_launch = "true"
  availability_zone = var.az1

}

resource "aws_subnet" "subnet-public-2" {
  vpc_id = aws_vpc.flex360-vpc.id
  cidr_block = var.subnet_public_2_cidr
  map_public_ip_on_launch = "true"
  availability_zone = var.az2

}

resource "aws_subnet" "subnet-private-1" {
  vpc_id = aws_vpc.flex360-vpc.id
  cidr_block = var.subnet_private_1_cidr
  map_public_ip_on_launch = "false"
  availability_zone = var.az1

}

resource "aws_subnet" "subnet-private-2" {
  vpc_id = aws_vpc.flex360-vpc.id
  cidr_block = var.subnet_private_2_cidr
  map_public_ip_on_launch = "false"
  availability_zone = var.az2

}

resource "aws_internet_gateway" "flex360-igw" {
  vpc_id = aws_vpc.flex360-vpc.id

}

resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.flex360-vpc.id

}

resource "aws_route_table_association" "subnet-public-1" {
  subnet_id = aws_subnet.subnet-public-1.id
  route_table_id = aws_route_table.rt-public.id

}

resource "aws_route_table_association" "subnet-public-2" {
  subnet_id = aws_subnet.subnet-public-2.id
  route_table_id = aws_route_table.rt-public.id

}
