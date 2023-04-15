resource "aws_vpc" "test_vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true

  tags = {
    "env" = "dev"
  }
}

resource "aws_subnet" "test_subnet" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_internet_gateway" "test_internet_gw" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_route_table" "test_route_table" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_route" "test_route" {
  route_table_id         = aws_route_table.test_route_table.id
  gateway_id             = aws_internet_gateway.test_internet_gw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "test_rt_a_1" {
  subnet_id      = aws_subnet.test_subnet.id
  route_table_id = aws_route_table.test_route_table.id
}
