variable "vpc_id" {
   description = "The ID of the VPC where the security group will be created"
}

variable my_IP {
    description = "The IP address or CIDR block that is allowed to access the EC2 instance via SSH"
}

variable key_pair_name {
    description = "The name of the key pair to be used for SSH access to the EC2 instance"
}

variable public_key_path {
    description = "The file path to the public key that will be used to create the key pair in AWS"
}

variable subnet_id {
    description = "The ID of the subnet where the EC2 instance will be launched"
}

variable avail_zone {
    description = "The availability zone where the EC2 instance will be launched"
}

variable env_prefix {
    description = "A prefix to be used for naming resources based on the environment (e.g., dev, prod)"
}

variable instance_type {
    description = "The type of EC2 instance to launch (e.g., t2.micro, t3.medium)"
}

variable image_name {
    description = "The name of the Amazon Machine Image (AMI) to use for the EC2 instance"
}
