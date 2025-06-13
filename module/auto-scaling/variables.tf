variable "ami" {
  description = "Value for the ami"
  type = string

}

variable "instance_type" {
  description ="Value for the instance-type"
  type = string

}

variable "key_name" {
  description = "Value for the Key pair"
  type = string
}

variable "private_subnet_ids" {
  description = "Value for the subnet"
  type = list(string)
}

variable "vpc_id" {
  description = "Value for VPC ID"
  type = string
}

variable "target_group_arns" {
  description = "List of target group ARNs to attach"
  type        = list(string)
}

