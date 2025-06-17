# Configure the AWS Provider
provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"
}

module "vpc" {
  source= "./module/vpc"
   public_subnets = {
    web-1 = {
      cidr_block        = "192.168.1.0/24"
      availability_zone = "us-east-1a"
    }
    web-2 = {
      cidr_block        = "192.168.2.0/24"
      availability_zone = "us-east-1b"
    }
  }
  private_subnets = {
    app-1 = {
      cidr_block        = "192.168.3.0/24"
      availability_zone = "us-east-1a"
    }
    app-2 = {
      cidr_block        = "192.168.4.0/24"
      availability_zone = "us-east-1b"
    }
    db-1 = {
      cidr_block        = "192.168.5.0/24"
      availability_zone = "us-east-1a"
    }
    db-2 = {
      cidr_block        = "192.168.6.0/24"
      availability_zone = "us-east-1b"
    }
  }
}


module "sg"{
  source = "./module/security-group"
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./module/iam"
  role_name = "s3Readonlyaccess"
}

module "rds" {
  source = "./module/rds"
  vpc_id = module.vpc.vpc_id
  db_subnet_ids = module.vpc.db_subnet_ids
  db_sg = module.sg.db_sg_id
  db_username = "admin"
  db_password = "Vijay1234"
}

module "alb" {
  source = "./module/alb"
  vpc_id             = module.vpc.vpc_id
  app_subnet_ids     = module.vpc.app_subnet_ids
  web_subnet_ids     = module.vpc.web_subnet_ids
  alb_sg             = module.sg.alb_sg_id
  ilb_sg             = module.sg.ilb_sg_id
}

module "auto-scaling" {
  source = "./module/auto-scaling"
  vpc_id = module.vpc.vpc_id
  ami = "ami-084568db4383264d4"
  app_sg = module.sg.app_sg_id
  web_sg = module.sg.app_sg_id
  target_app_group_arns = module.alb.app_target_group_arns
  target_web_group_arns = module.alb.web_target_group_arns
  app_subnet_ids =   module.vpc.app_subnet_ids
  web_subnet_ids =  module.vpc.web_subnet_ids
  key_name = "vpc"
  db_endpoint = module.rds.rds_host
  db_username = "admin"
  db_password = "Vijay1234"
  s3_bucket = "app2-workbook-example.com"
  alb_dns = module.alb.alb_dns
  profilename = module.iam.instance_profile_name

}

module "bastion-server" {
  source = "./module/ec2-instance"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.web_subnet_ids
  key_name = "vpc"
  ami = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  web_sg = module.sg.web_sg_id
}

module "route53"{
  source = "./module/route53"
  alb_dns_name = module.alb.alb_dns
  zone_id = module.alb.alb_zone_id
}



