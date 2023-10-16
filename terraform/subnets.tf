resource "aws_subnet" "private-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.68.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "private-a"
  }
}

resource "aws_subnet" "private-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.69.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "private-b"
  }
}

resource "aws_subnet" "public-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.70.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name                     = "public-a"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "public-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.71.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name                     = "public-b"
    "kubernetes.io/role/elb" = 1
  }
}