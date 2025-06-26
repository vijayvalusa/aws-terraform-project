# variables.tf

variable "public_subnets" {
  description = "Map of public subnet configurations"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "private_subnets" {
  description = "Map of private subnet configurations"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "db_username" {
  description = "RDS username"
  type        = string
}

variable "db_password" {
  description = "RDS password"
  type        = string
  sensitive   = true
}

variable "ami" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "key_name" {
  description = "Key pair name for EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for Route 53 and ALB"
  type        = string
}

variable "role_name" {
  description = "IAM role name"
  type        = string
}
