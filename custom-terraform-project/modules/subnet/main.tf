resource "aws_subnet" "myproject-subnet-1" {
  vpc_id            = var.vpc_id #we have to redefine the vpc variable since it is not referenced here.
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "myproject-igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

resource "aws_default_route_table" "main-default-rtb" {
  default_route_table_id = var.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myproject-igw.id  #we don't need to redefine this variable because the 
    #gateway_id is referenced inside this document.
    
  }
  tags = {
    Name = "${var.env_prefix}-main-default-rtb"
  }
}
