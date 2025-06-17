variable "ami" {
  description = "Value for the ami"
  type = string

}

variable "key_name" {
  description = "Value for the Key pair"
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

variable "vpc_id" {
  description = "Value for VPC ID"
  type = string
}

variable "target_web_group_arns" {
  description = "List of target group ARNs to attach"
  type        = list(string)
}

variable "target_app_group_arns" {
  description = "List of target group ARNs to attach"
  type        = list(string)
}

variable "app_sg" {
  description = "Allow to connect app server"
  type = list(string)
  
}

variable "web_sg" {
  description = "Allow to connect web server"
  type = list(string)
  
}

variable "db_username" {
  description = "Value of db username"
  type = string
}

variable "db_password" {
  description = "Value of db password"
  type = string
}

variable "db_endpoint" {
  description = "RDS endpoint to be passed into user_data script"
  type        = string
}

variable "alb_dns" {
  description = "RDS endpoint to be passed into user_data script"
  type        = string
}

variable "profilename" {
  description = "value of policy name"
  type = string
}

variable "s3_bucket" {
  description = "value of policy name"
  type = string
}