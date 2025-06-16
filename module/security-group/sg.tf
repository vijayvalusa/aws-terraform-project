#Security Group for Application Load Balancer
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP to connect Application Load balancer"
  vpc_id      = var.vpc_id 

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB-SG"
  }
}


#Security Group for Web applications
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = var.vpc_id 

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WEB-SG"
  }
}


#Security Group for Internal Load Balancer
resource "aws_security_group" "ilb_sg" {
  name        = "ilb-sg"
  description = "Allow Web Server inbound traffic"
  vpc_id      = var.vpc_id 

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ILB-SG"
  }
}

resource "aws_security_group_rule" "allow_web_to_ilb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ilb_sg.id            # Target SG
  source_security_group_id = aws_security_group.web_sg.id             # Source SG
  description              = "Allow 80 from web_sg to ilb_sg"
}

#Security Group for Application server
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow Internal Load Balancer inbound traffic"
  vpc_id      = var.vpc_id 

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "APP-SG"
  }
}


resource "aws_security_group_rule" "allow_ilb_to_app" {
  type                     = "ingress"
  from_port                = 4000
  to_port                  = 4000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id           # Target SG
  source_security_group_id = aws_security_group.ilb_sg.id             # Source SG
  description              = "Allow 4000 from ilb_sg to app_sg"
}


#Security Group for database server
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow Application server inbound traffic"
  vpc_id      = var.vpc_id 

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB-SG"
  }
}


resource "aws_security_group_rule" "allow_app_to_db" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id          # Target SG
  source_security_group_id = aws_security_group.app_sg.id         # Source SG
  description              = "Allow 3306 from app_sg to db_sg"
}
