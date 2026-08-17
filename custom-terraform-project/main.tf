provider "aws" {}

resource "aws_vpc" "myproject-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "myproject-subnet" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone        = var.avail_zone
  env_prefix        = var.env_prefix
  vpc_id            = aws_vpc.myproject-vpc.id
  default_route_table_id = aws_vpc.myproject-vpc.default_route_table_id
}

/*
resource "aws_instance" "myproject-server" {
  ami           = data.aws_ami.latest_amazon_linux_image.id
  instance_type = var.instance_type

  subnet_id     = module.myproject-subnet.subnet.id  # using a child module output to get the subnet ID
  vpc_security_group_ids = [aws_security_group.myproject-sg.id]
  availability_zone = var.avail_zone

  associate_public_ip_address = true

  key_name = aws_key_pair.myproject-key-pair.key_name

  user_data = file("startup-script.sh")
  
  user_data_replace_on_change = true

  tags = {
    Name = "${var.env_prefix}-myproject-server"
  }
}
*/

module "myproject-webserver" {
  source = "./modules/webserver"
  vpc_id = aws_vpc.myproject-vpc.id
  subnet_id = module.myproject-subnet.subnet.id #note that subnet here is the name of the output variable defined in the subnet module.
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  my_IP = var.my_IP
  instance_type = var.instance_type
  key_pair_name = var.key_pair_name
  public_key_path = var.public_key_path
  image_name = var.image_name
}



