#Create VPC
resource "aws_vpc" "vpc" {
  cidr_block  = var.vpc_cidr
  tags = {
    Name = "aws-prod-demo"
  }
}

#Create public Subnet using for_each loop
resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${each.key}"
    Role = split("-", each.key)[0] # web, app, db
  }
}


#Create Private Subnet using for_each loop
resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "private-subnet-${each.key}"
    Role = split("-", each.key)[0] # web, app, db
  }
}


#Create Internetgateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "prod-aws-igw"
  }
}

#Create route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"  # Required for EIP to be used in VPC
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = element(values(aws_subnet.public), 0).id
  depends_on = [aws_eip.nat_eip]
  tags = {
    Name = "NAT-Gateway"
  }
}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private-Route-Table"
  }
}


resource "aws_route_table_association" "private_rt_assoc" {
  for_each = { for k, v in aws_subnet.private : k => v if contains(["us-east-1a"], v.availability_zone) }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}

