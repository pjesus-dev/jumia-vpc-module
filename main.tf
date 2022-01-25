#Definition of VPC

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  tags = merge(var.shared_tags , { Name = "${lookup(var.shared_tags, "Env", "")}-vpc"})
}

#Definition of Internet Gateway

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.shared_tags , { Name = "${lookup(var.shared_tags, "Env", "")}-igw"})
}

#-------------------Public Subnets and Routing-------------------

resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnet_cidrs
  vpc_id = aws_vpc.main.id
  cidr_block = each.key
  availability_zone = each.value
  map_public_ip_on_launch = true
  tags = merge(var.shared_tags, { Name = "${lookup(var.shared_tags, "Env", "")}-public-subnet-${each.key}"})
}

resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(var.shared_tags, { Name = "${lookup(var.shared_tags, "Env", "")}-routes-public-subnets"})
}

resource "aws_route_table_association" "public_subnets" {
  count = length([for s in aws_subnet.public_subnets: s.id])
  route_table_id = aws_route_table.public_subnets.id
  subnet_id = element([for s in aws_subnet.public_subnets: s.id], count.index)
}


