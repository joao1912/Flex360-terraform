resource "aws_eip" "eip-ngw-1" {
  vpc = true

}

resource "aws_nat_gateway" "ngw-1" {
  allocation_id = aws_eip.eip-ngw-1.id
  subnet_id     = aws_subnet.subnet-public-1.id
  depends_on    = [aws_internet_gateway.main-igw]
  
}

resource "aws_route_table" "rt-private" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-1.id
  }

}

resource "aws_route_table_association" "subnet-private-1" {
  subnet_id      = aws_subnet.subnet-private-1.id
  route_table_id = aws_route_table.rt-private.id

}

resource "aws_route_table_association" "subnet-private-2" {
  subnet_id      = aws_subnet.subnet-private-2.id
  route_table_id = aws_route_table.rt-private.id

}