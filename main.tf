# Configure the AWS Provider
provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"
}

module "vpc" {
  source= "./module/vpc"
   public_subnets = {
    1 = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    }
    2 = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    }
  }
  private_subnets = {
    1 = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1a"
    }
    2 = {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-1b"
    }
  }
}

module "alb" {
  source = "./module/alb"
  public_subnet_ids = module.vpc.public_subnet_ids
  vpc_id = module.vpc.vpc_id
}

module "auto-scaling" {
  source = "./module/auto-scaling"
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id = module.vpc.vpc_id
  key_name = "vpc-1"
  ami = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  target_group_arns = [module.alb.target_group_arn]
}

module "bastion-server" {
  source = "./module/ec2-instance"
  subnet_id = module.vpc.public_subnet_ids
  vpc_id = module.vpc.vpc_id
  key_name = "vpc"
  ami = "ami-084568db4383264d4"
  instance_type = "t2.micro"
}

module "route53"{
  source = "./module/route53"
  lb_dns_name = module.alb.alb_dns
  zone_id = module.alb.alb_zone_id
}



