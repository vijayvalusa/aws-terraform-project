resource "aws_instance" "ami_builder" {
  ami                         = var.source_ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id[0]
  vpc_security_group_ids      = var.web_sg
  associate_public_ip_address = true
  key_name                    = var.key_name
  user_data                   = file("${path.module}/user_data.sh")

  tags = {
    Name = "ami-builder-instance"
  }
}

resource "aws_ami_from_instance" "custom" {
  name               = "app-custom-${timestamp()}"
  source_instance_id = aws_instance.ami_builder.id

  tags = {
    Name = "app-custom-ami"
  }
}


