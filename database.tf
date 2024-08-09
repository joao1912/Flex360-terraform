
resource "aws_db_subnet_group" "rds-subnet-group" {

  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.subnet-private-3.id, aws_subnet.subnet-private-4.id]

}

resource "aws_security_group_rule" "ingress-rds-rule" {

  to_port                  = 5432
  from_port                = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg-db.id
  type                     = "ingress"
  source_security_group_id = aws_security_group.sg-ec2-flex360.id

}

resource "aws_security_group_rule" "egress-rds-rule" {

  to_port           = 0
  from_port         = 0
  protocol          = -1
  security_group_id = aws_security_group.sg-db.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]

}

resource "aws_security_group" "sg-db" {

  vpc_id      = aws_vpc.flex360-vpc.id
  name        = "database"
  description = "Acesso tcp via ec2 do grupo de auto-scaling"

}

resource "aws_db_instance" "database-flex360" {

  identifier          = "database-flex360"
  engine              = "mysql"
  engine_version      = "8.0.23"
  instance_class      = "db.t2.micro"
  username            = "joao"
  password            = "senha123"
  allocated_storage   = 5
  storage_type        = "gp2"
  publicly_accessible = false

  skip_final_snapshot = true

  backup_retention_period = 7
  multi_az                = false

  db_name                = "flex360"
  vpc_security_group_ids = [aws_security_group.sg-db.id]
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group.name

}
