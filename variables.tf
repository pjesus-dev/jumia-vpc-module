#-----------------VPC Variables----------------

variable "vpc_cidr" {
  description = "Private CIDR to be used on VPC"
  type = string
  default = ""
}

#------------------Public Subnets-------------------

variable "public_subnet_cidrs" {
  description = "List of each public subnet CIRD that you want to create"
  type = map
  default = {}
}

#------------------Public Subnets-------------------

variable "shared_tags" {
  type = map
  description = "Common tags to all resources"
  default = {
    Owner = ""
    Team = ""
    Project = ""
    Env = ""
  }
}





