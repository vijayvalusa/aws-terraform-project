variable "vpc_id" {
  description = "The Value of VPC ID"
  type = string
}

variable "db_subnet_ids" {
  type = list(string)
}

variable "db_username" {
  description = "Username for RDS"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for RDS"
  type        = string
  sensitive   = true
}

variable "db_sg" {
  description = "Allow to connect db server"
  type = list(string)
  
}
