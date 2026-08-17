resource "aws_security_group" "myproject-sg" {
  name        = "${var.env_prefix}-myproject-sg"
  description = "Security group for ${var.env_prefix} environment"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.my_IP
  }

  ingress {
    from_port   = 8080   #from_port and to_port represent range of port e.g. (1000-35001)
    to_port     = 8080   #from_port and to_port should be the same for a single port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-myproject-sg"
  }
}

data "aws_ami" "latest_amazon_linux_image" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.image_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "myproject-key-pair" {
  key_name   = var.key_pair_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "myproject-server" {
  ami           = data.aws_ami.latest_amazon_linux_image.id
  instance_type = var.instance_type

  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.myproject-sg.id]
  availability_zone = var.avail_zone

  associate_public_ip_address = true

  key_name = aws_key_pair.myproject-key-pair.key_name

  user_data = file("${path.module}/startup-script.sh")

  user_data_replace_on_change = true

  tags = {
    Name = "${var.env_prefix}-myproject-server"
  }
}
