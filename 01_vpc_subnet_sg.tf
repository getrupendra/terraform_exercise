# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
  }
}

# Create a public subnet
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

# Create a private subnet
#resource "aws_subnet" "private_subnet_1" {
#  vpc_id            = aws_vpc.my_vpc.id
#  cidr_block        = "10.0.2.0/24"
#
#  tags = {
#    Name = "private-subnet-1"
#  }
#}

# Create an internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-igw"
  }
}

# Create a route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate the public subnet with the route table
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id

}
