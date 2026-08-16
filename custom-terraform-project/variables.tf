variable region {
  type        = string
  default     = ""
  description = "region to be used"
}

# variable cidr_blocks {
#   type        = list(objects({
#     cidr_block = string
#     name       = string
#   }))
#   description = "cidr blocks and name tags for vpc and subnet"
# }

variable vpc_cidr_block {
  type        = string
  default     = ""
  description = "vpc cidr block to be used"
}

variable subnet_cidr_block {
  type        = string
  default     = ""
  description = "subnet cidr block to be used"
}

variable avail_zone {
  type        = string
  default     = ""
  description = "availability zone to be used"
}

variable env_prefix {
  type        = string
  default     = ""
  description = "environment prefix to be used"
}

variable my_IP {
  type        = list(string)
  description = "my IP address"
}

variable instance_type {
  type        = string
  description = "EC2 instance type to be used"
}

variable key_pair_name {
  type        = string
  description = "Key pair name to be used for EC2 instance"
}

variable public_key_path {
  type        = string
  description = "Path to the public key file for the key pair"
}

variable private_key_path {
  type        = string
  description = "Path to the private key file for the key pair"
}


