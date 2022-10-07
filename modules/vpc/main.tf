terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.33.0"
    }
  }
}

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Week-18-${var.AWS-Two-Teir-Architecture}-OmarEgal"
  }
}

# Create VPC Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Internet_Gateway"
  }
}

# Create public subnets
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_sbn_cidr_ranges)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.public_sbn_cidr_ranges, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "public-sbn-${count.index + 1}"
    Tier = "Public"
  }
}


# Create private subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_sbn_cidr_ranges)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_sbn_cidr_ranges, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "private-sbn-${count.index + 1}"
    Tier = "Private"
  }
}

# Create a route to the internet
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Create association for public route
resource "aws_route_table_association" "public_sbn_association" {
  count          = length(var.public_sbn_cidr_ranges)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_route.id
}


