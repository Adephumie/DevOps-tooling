data "aws_ami" "myserver-ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_image_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "myapp-server" {
    instance_type = var.instance_type
    ami = data.aws_ami.myserver-ami.id
}