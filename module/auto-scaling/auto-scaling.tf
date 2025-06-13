resource "aws_security_group" "asg_sg" {
  name        = "asg-sg"
  description = "Allow HTTP"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Be careful using this in production
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "asg-security-group"
  }


}


resource "aws_launch_template" "web_template" {
  name_prefix   = "web-"
  image_id      = var.ami           # e.g., Ubuntu AMI
  instance_type = "t2.micro"
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.asg_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-asg-instance"
    }
  }
}


resource "aws_autoscaling_group" "web_asg" {
  name  =   "aws-prod-demo"
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = var.private_subnet_ids   # List of subnets
  health_check_type    = "EC2"
  target_group_arns   = var.target_group_arns                    # Optional: for ALB
  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-asg"
    propagate_at_launch = true
  }
}

