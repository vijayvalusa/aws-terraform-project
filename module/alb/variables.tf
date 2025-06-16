variable "vpc_id" {
  description = "Value for VPC ID"
  type = string
}

variable "app_subnet_ids" {
  description = "Value for the subnet"
  type = list(string)
}

variable "web_subnet_ids" {
  description = "Value for the subnet"
  type = list(string)
}

variable "ilb_sg" {
  description = "Value for the subnet"
  type = list(string)
}

variable "alb_sg" {
  description = "Value for the subnet"
  type = list(string)
}
