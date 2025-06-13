#creating EC2 Instance

resource "aws_instance" "web-server" {
  ami           =  var.ami # Ubuntu AMI (us-east-1)
  instance_type =  var.instance_type
  subnet_id     =  var.subnet_id[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name = var.key_name
  tags = {
    Name = "bastion-server"
  }
}


resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = var.vpc_id  # Replace with your VPC ID

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Be careful using this in production
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

