variable "vpc_id" {
  description = "Value for VPC ID"
  type = string
}

variable "public_subnet_ids" {
  description = "Value for the subnet"
  type = list(string)
}
