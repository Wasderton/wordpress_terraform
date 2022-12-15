# ---------------------------------------------------------
# NEW VPC
# ---------------------------------------------------------

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Terraform VPC"
  }
}


# ---------------------------------------------------------
# Internet_gateway
# ---------------------------------------------------------

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}


# ---------------------------------------------------------
# PUBLIC SUBNETS
# ---------------------------------------------------------

resource "aws_subnet" "pub_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-central-1a"

  map_public_ip_on_launch = true
}

resource "aws_subnet" "pub_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-central-1b"

  map_public_ip_on_launch = true
}


# ---------------------------------------------------------
# PRIVATE SUBNETS
# ---------------------------------------------------------

resource "aws_subnet" "prv_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "prv_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.8.0/24"
  availability_zone = "eu-central-1b"

}


# ---------------------------------------------------------
# ROUTE_TABLES
# ---------------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "route_table_association1" {
  subnet_id      = aws_subnet.pub_subnet1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "route_table_association_prv" {
  subnet_id      = aws_subnet.prv_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "route_table_association_prv1" {
  subnet_id      = aws_subnet.prv_subnet1.id
  route_table_id = aws_route_table.public.id
}


# ---------------------------------------------------------
# RDS SUBNET 
# ---------------------------------------------------------

resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = [aws_subnet.prv_subnet.id, aws_subnet.prv_subnet1.id]
}
