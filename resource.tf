resource "aws_vpc" "prime" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "prime"
  }
}

# creating an IGW 
#https://registry.terraform.io/providers/aaronfeng/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "prime-IGW" {
  vpc_id = aws_vpc.prime.id

  tags = {
    Name = "prime-IGW"
  }
}

# creating a public subnet1
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet.html

resource "aws_subnet" "prime-pub1" {
  vpc_id     = aws_vpc.prime.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prime-pub1"
  }
}

# creating a public subnet2
resource "aws_subnet" "prime-pub2" {
  vpc_id     = aws_vpc.prime.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "prime-pub2"
  }
}

# creating a route table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table.html
resource "aws_route_table" "prime-pub-route-table" {
  vpc_id = aws_vpc.prime.id

  route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.prime-IGW.id
  }

  tags = {
    Name = "prime-pub-route-table"

  }
}

# associating route table to pub1
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

resource "aws_route_table_association" "prime-pub1" {
  subnet_id      = aws_subnet.prime-pub1.id
  route_table_id = aws_route_table.prime-pub-route-table.id
}

# associating route table to pub2
resource "aws_route_table_association" "prime-pub2" {
  subnet_id      = aws_subnet.prime-pub2.id
  route_table_id = aws_route_table.prime-pub-route-table.id
}

# creating a private subnet
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet.html

resource "aws_subnet" "prime-private1" {
  vpc_id     = aws_vpc.prime.id
  cidr_block = "10.0.3.0/24"
  availability_zone ="us-east-1a"

  tags = {
    Name = "prime-private1"
  }
}

# creating a private subnet
resource "aws_subnet" "prime-private2" {
  vpc_id     = aws_vpc.prime.id
  cidr_block = "10.0.4.0/24"
  availability_zone ="us-east-1b"

  tags = {
    Name = "prime-private2"
  }
}

# creating a route table
resource "aws_route_table" "private-route_table" {
  vpc_id = aws_vpc.prime.id

  route = []

  tags = {
    Name = "prime-private-route-table"
  }
}

# associating route table to private subnet
resource "aws_route_table_association" "prime-private1" {
  subnet_id      = aws_subnet.prime-private1.id
  route_table_id = aws_route_table.private-route_table.id
}

# associating route table to private subnet
resource "aws_route_table_association" "prime-private2" {
  subnet_id      = aws_subnet.prime-private2.id
  route_table_id = aws_route_table.private-route_table.id
}
