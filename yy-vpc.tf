# -----------------------------
# VPC
# -----------------------------
resource "aws_vpc" "vpc_main" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project}-${var.env}-vpc"
  }
}

# -----------------------------
# Subnet
# -----------------------------
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.vpc_main.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.10.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project}-${var.env}-subnet-public-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.vpc_main.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.168.20.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project}-${var.env}-subnet-public-1c"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id                  = aws_vpc.vpc_main.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.30.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project}-${var.env}-subnet-private-1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id                  = aws_vpc.vpc_main.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.168.40.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project}-${var.env}-subnet-private-1c"
  }
}

# -----------------------------
# Route Table
# -----------------------------
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    Name = "${var.project}-${var.env}-rt-public"
  }
}

resource "aws_route_table_association" "rta_public_1a" {
  route_table_id = aws_route_table.rt_public.id
  subnet_id      = aws_subnet.public_1a.id
}

resource "aws_route_table_association" "rta_public_1c" {
  route_table_id = aws_route_table.rt_public.id
  subnet_id      = aws_subnet.public_1c.id
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    Name = "${var.project}-${var.env}-rt-private"
  }
}

resource "aws_route_table_association" "rta_private_1a" {
  route_table_id = aws_route_table.rt_private.id
  subnet_id      = aws_subnet.private_1a.id
}

resource "aws_route_table_association" "rta_private_1c" {
  route_table_id = aws_route_table.rt_private.id
  subnet_id      = aws_subnet.private_1c.id
}

# -----------------------------
# Route Table
# -----------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    Name = "${var.project}-${var.env}-igw"
  }
}

resource "aws_route" "route_public_rt_igw_r" {
  route_table_id         = aws_route_table.rt_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
