provider "aws" {
  region = var.region
}

resource "aws_vpc" "my-test-vpc" {
  cidr_block = var.cidr_blocks[0]
  tags = {
    Name = "my-test-vpc-${var.environment[0]}"
    environment = var.environment[0]
  }
}

resource "aws_subnet" "my-test-subnet-1" {
  vpc_id            = aws_vpc.my-test-vpc.id
  cidr_block        = var.cidr_blocks[1]
  availability_zone = "${var.region}a"
  tags = {
    Name = "my-test-subnet-1-${var.environment[0]}"
    environment = var.environment[0]
  }
}

resource "aws_subnet" "my-test-subnet-2" {
  vpc_id            = aws_vpc.my-test-vpc.id
  cidr_block        = var.cidr_blocks[2]
  availability_zone = "${var.region}b"
  tags = {
    Name = "my-test-subnet-2-${var.environment[0]}"
    environment = var.environment[0]
  }
}