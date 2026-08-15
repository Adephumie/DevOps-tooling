provider "aws" {}

resource "aws_vpc" "myproject-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myproject-subnet-1" {
  vpc_id            = aws_vpc.myproject-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}

/*resource "aws_route_table" "myproject-route-table" {
  vpc_id            = aws_vpc.myproject-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myproject-igw.id
  }
  tags = {
    Name = "${var.env_prefix}-rtb"
  }
}*/

resource "aws_internet_gateway" "myproject-igw" {
  vpc_id = aws_vpc.myproject-vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

/*resource "aws_route_table_association" "rtb-subnet1-assoc" {
  subnet_id      = aws_subnet.myproject-subnet-1.id
  route_table_id = aws_route_table.myproject-route-table.id
}*/

resource "aws_default_route_table" "main-default-rtb" {
  default_route_table_id = aws_vpc.myproject-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myproject-igw.id
  }
  tags = {
    Name = "${var.env_prefix}-main-default-rtb"
  }
}

resource "aws_security_group" "myproject-sg" {
  name        = "${var.env_prefix}-myproject-sg"
  description = "Security group for ${var.env_prefix} environment"
  vpc_id      = aws_vpc.myproject-vpc.id

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

/*Note that whenever a VPC is created in AWS, a default security group is also created.
Instead of creating a new security group, you can also modify the default security group 
to allow the ports that you need. 
However, creating a new security group is a better practice as it allows for more 
granular control over access to your resources.*/

/*resource "aws_default_security_group" "myproject-default-sg" {
  vpc_id      = aws_vpc.myproject-vpc.id

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
    Name = "${var.env_prefix}-myproject-default-sg"
  }
}*/

# EC2 instance creation

# To dynamically use ami values, it best to use the aws_ami data source to fetch the latest ami for a given OS.
data "aws_ami" "latest_amazon_linux_image" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

/*Key pair can be created automatically. Doing it manually isn't optimal. For this, you would need to
generate an SSH key using the ssh-keygen command and then use the public key to create a key pair in AWS.
The ssh-keygen command will generate a public (with .pub extension), and a private key without the .pub extension.
*/

resource "aws_key_pair" "myproject-key-pair" {
  key_name   = var.key_pair_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "myproject-server" {
  ami           = data.aws_ami.latest_amazon_linux_image.id
  instance_type = var.instance_type

  subnet_id     = aws_subnet.myproject-subnet-1.id
  vpc_security_group_ids = [aws_security_group.myproject-sg.id]
  availability_zone = var.avail_zone

  associate_public_ip_address = true

  /*Create a key pair (.ppk or .pem), move the downloaded file to the .ssh folder to secure it and
  change its permission to 400 using chmod command. Then, use the key name in the below line to 
  connect to the instance.
  To SSH into the instance, use the command: ssh -i /path/to/key.pem ec2-user@<public-ip-address>
  Note that the key.pem or key.ppk file is the file that you downloaded while creating the key pair in AWS.
  */
  
  # key_name = server-key-pair

  /*Another method of referencing key pairs is using the auto-generated key pair from the aws_key_pair 
  resource above*/

  key_name = aws_key_pair.myproject-key-pair.key_name

  /*To connect to the server that was created, you would use the command:
    ssh -i path-to-key-pair-file ec2-user@<public-ip-address>
    Note that the file you will use will be the private one (without the .pub extension) 
    that was generated when you created the key pair. 
    The public key is used to create the key pair in AWS, 
    while the private key is used to connect to the server.
  */

  /*
    user_data = <<-EOF
                  #!/bin/bash
                  sudo yum update -y && sudo yum install -y docker
                  sudo systemctl start docker
                  sudo usermod -aG docker ec2-user
                  docker run -p 8080:80 nginx
                EOF
  */

  /*If you have a script that holds many lines of code, you can make it into a script and parse it into
  the user data argument using the file() function. 
  */

  user_data = file("startup-script.sh")
  
  user_data_replace_on_change = true

  tags = {
    Name = "${var.env_prefix}-myproject-server"
  }
}


