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

variable "vpc_id" {
  description = "Value for VPC ID"
  type = string
}

variable "subnet_id" {
  description = "Value for Subnet ID"
  type = list(string)
}

variable "web_sg" {
   description = "Value for Security Group"
   type = list(string)
  
}


