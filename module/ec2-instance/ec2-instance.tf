#creating EC2 Instance
resource "aws_instance" "web-server" {
  ami           =  var.ami # Ubuntu AMI (us-east-1)
  instance_type =  var.instance_type
  subnet_id     =  var.subnet_id[0]
  vpc_security_group_ids = var.web_sg
  key_name = var.key_name
  tags = {
    Name = "bastion-server"
  }
}

