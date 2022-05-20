resource "aws_vpc" "vpc_prueba_simetrik" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true

    tags = {
      "Name" = var.tags
    }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.vpc_prueba_simetrik.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "private subnet 1"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.vpc_prueba_simetrik.id
  cidr_block        = var.public_subnet1_cidr
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "public subnet 1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.vpc_prueba_simetrik.id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = "us-east-1b"
  
  tags = {
    Name = "private subnet 2"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.vpc_prueba_simetrik.id
  cidr_block        = var.public_subnet2_cidr
  availability_zone = "us-east-1b"
  
  tags = {
    Name = "public subnet 2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_prueba_simetrik.id

  tags = {
    "Name" = "Internet Gateway para VPN test Simetrik"
  }

  depends_on = [
    aws_vpc.vpc_prueba_simetrik
  ]
}

resource "aws_route_table" "public_rt_1" {
  vpc_id = aws_vpc.vpc_prueba_simetrik.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "Public Route Table 1"
  }
}

resource "aws_route_table_association" "public_table_1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rt_1.id
}

resource "aws_route_table" "public_rt_2" {
  vpc_id = aws_vpc.vpc_prueba_simetrik.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "Public Route Table 2"
  }
}

resource "aws_route_table_association" "public_table_2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rt_2.id
}

resource "aws_eip" "eip_1" {
  vpc = true

  tags = {
    "Name" = "Elastic IP para NAT gw"
  }
}

resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.eip_1.id
  subnet_id     = aws_subnet.public_subnet1.id  

  tags = {
    "Name" = "Nat Gateway 1"
  }
}

resource "aws_eip" "eip_2" {
  vpc = true

  tags = {
    "Name" = "Elastic IP para NAT gw"
  }
}

resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = aws_eip.eip_2.id
  subnet_id     = aws_subnet.public_subnet2.id  

  tags = {
    "Name" = "Nat Gateway 2"
  }
}

resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.vpc_prueba_simetrik.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_1.id
  }

  tags = {
    "Name" = "Private Route Table 1"
  }
}

resource "aws_route_table_association" "private_table_1" {
  subnet_id = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rt_1.id
}

resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.vpc_prueba_simetrik.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_2.id
  }

  tags = {
    "Name" = "Private Route Table 2"
  }
}

resource "aws_route_table_association" "private_table_2" {
  subnet_id = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_rt_2.id
}