locals {
  instance_type = "t2.micro"
}


resource "aws_launch_template" "app_template" {
  name_prefix   = "app-"
  image_id      = var.ami           # e.g., Ubuntu AMI
  instance_type = local.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.app_sg
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "app-server"
    }
  }
}

resource "aws_launch_template" "web_template" {
  name_prefix   = "web-"
  image_id      = var.ami           # e.g., Ubuntu AMI
  instance_type = local.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.web_sg
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-server"
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name  =   "aws-prod-app-asg"
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = var.app_subnet_ids   # List of subnets

  health_check_type    = "EC2"
  target_group_arns   = var.target_app_group_arns                    # Optional: for ALB
  health_check_grace_period = 300
  termination_policies      = ["OldestInstance"]

  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "app-asg"
    propagate_at_launch = true
  }
}



resource "aws_autoscaling_group" "web_asg" {
  name  =   "aws-prod-web-asg"
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = var.web_subnet_ids   # List of subnets
  health_check_type    = "EC2"
  target_group_arns   = var.target_web_group_arns                 # Optional: for ALB
  health_check_grace_period = 300
  termination_policies      = ["OldestInstance"]

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



