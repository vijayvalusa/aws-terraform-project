# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source= "./module/vpc"
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets 
}


module "sg"{
  source = "./module/security-group"
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./module/iam"
  role_name = var.role_name
}

module "rds" {
  source = "./module/rds"
  vpc_id = module.vpc.vpc_id
  db_subnet_ids = module.vpc.db_subnet_ids
  db_sg = module.sg.db_sg_id
  db_username = var.db_username
  db_password = var.db_password

}

module "alb" {
  source = "./module/alb"
  vpc_id             = module.vpc.vpc_id
  app_subnet_ids     = module.vpc.app_subnet_ids
  web_subnet_ids     = module.vpc.web_subnet_ids
  alb_sg             = module.sg.alb_sg_id
  ilb_sg             = module.sg.ilb_sg_id
  domain_name        = var.domain_name
}

module "auto-scaling" {
  source = "./module/auto-scaling"
  vpc_id = module.vpc.vpc_id
  ami = var.ami
  app_sg = module.sg.app_sg_id
  web_sg = module.sg.web_sg_id
  target_app_group_arns = module.alb.app_target_group_arns
  target_web_group_arns = module.alb.web_target_group_arns
  app_subnet_ids =   module.vpc.app_subnet_ids
  web_subnet_ids =  module.vpc.web_subnet_ids
  key_name = var.key_name
  db_endpoint = module.rds.rds_host
  db_username = var.db_username
  db_password = var.db_password
  s3_bucket = var.s3_bucket
  ilb_dns = module.alb.ilb_dns
  profilename = module.iam.instance_profile_name
}

module "bastion-server" {
  source = "./module/ec2-instance"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.web_subnet_ids
  key_name = var.key_name
  ami = var.ami
  instance_type = var.instance_type
  web_sg = module.sg.web_sg_id
}

module "route53"{
  source = "./module/route53"
  alb_dns_name = module.alb.alb_dns
  zone_id = module.alb.alb_zone_id
}



