variable region {
  type        = string
  default     = ""
  description = "region to be used"
}

# variable vpc_cidr_block {
#   type        = string
#   default     = ""
#   description = "CIDR value for the VPC created"
# }

# variable subnet1_cidr_block {
#   type        = string
#   default     = ""
#   description = "CIDR value for the Subnet 1 created"
# }

# variable subnet2_cidr_block {
#   type        = string
#   default     = ""
#   description = "CIDR value for the Subnet 2 created"
# }

variable cidr_blocks {
  type        = list(string)
  default     = []
  description = "CIDR value for the list of cidrs needed for the environment"
}

variable environment {
  type        = list(string)
  default     = []
  description = "environment to deploy resources to"
}