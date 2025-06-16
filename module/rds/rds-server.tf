#Create subnet Group for high availability
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "DB-Subnet-Group"
  }
}

#Create RDS Servers
resource "aws_db_instance" "mysql_db" {
  identifier              = "db-mysql"
  engine                  = "mysql"
  engine_version          = "8.0.41"
  instance_class          = "db.t4g.micro"         # Free tier eligible
  allocated_storage       = 20 
  db_name                 = "inventory_db"
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false                 # SINGLE AZ ONLY
  deletion_protection     = false
  auto_minor_version_upgrade = false  
  backup_retention_period = 0                    
              
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = var.db_sg

  tags = {
    Name = "MySQL-RDS"
  }
}
