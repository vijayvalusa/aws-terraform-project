# prod.tfvars

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

db_username = "admin"
db_password = "Vijay1234"

ami         = "ami-084568db4383264d4"
key_name    = "vpc"
instance_type = "t2.micro"

s3_bucket   = "app2-workbook-example.com"
domain_name = "demovijay.xyz"

role_name = "s3Readonlyaccess"
