resource "aws_vpc" "test_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    "env" = "dev"
  }
}


resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available_azs.names[1]
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available_azs.names[2]
}

resource "aws_internet_gateway" "test_internet_gw" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  gateway_id             = aws_internet_gateway.test_internet_gw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "pvt_rt_a_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "pvt_rt_a_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}