resource "aws_vpc" "vpc" {
    cidr_block           = var.vpc_cidr_block
    enable_dns_hostnames = true

    tags = {
      "Name"             = "Group11_lab1"
    }

}

resource "aws_subnet" "private_subnet" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.private_subnet

    tags = {
      "Name"          = "private_subnet"
    }
}


resource "aws_subnet" "public_subnet" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.public_subnet
    tags = {
      "Name"          = "public_subnet"
    }
}


resource "aws_internet_gateway" "ig" {
    vpc_id      = aws_vpc.vpc.id

    tags = {
      "Name"    = "Group11_ig"
    }
}


resource "aws_route_table" "public" {
  
    vpc_id         = aws_vpc.vpc.id


    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ig.id
    }

    tags = {
        "Name"     = "Group11_Route_table"
    }
}



resource "aws_route_table_association" "public_associatoin" {
  subnet_id       = aws_subnet.public_subnet.id
  route_table_id  = aws_route_table.public.id
}


resource "aws_eip" "nat" {
    vpc = true
}


resource "aws_nat_gateway" "public" {
  depends_on    = [aws_internet_gateway.ig]

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet.id
  
  tags = {
    Name        = "Public NAT"  
  }
}


resource "aws_route_table" "private" {
  vpc_id        = aws_vpc.vpc.id

  route{
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_nat_gateway.public.id
  }

  tags = {
    "Name"      = "private"
  }
}


resource "aws_route_table_association" "public_private" {
  subnet_id             = aws_subnet.private_subnet.id
  route_table_id        = aws_route_table.private.id
}


