variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Map of public subnet CIDRs and AZs"
  type = map(object({
    cidr_block        : string
    availability_zone : string
  }))
}

variable "private_subnets" {
  description = "Map of private subnet CIDRs and AZs"
  type = map(object({
    cidr_block        : string
    availability_zone : string
  }))
}

