output "rds_endpoint" {
  value = aws_db_instance.mysql_db.endpoint
}

output "rds_host" {
  value = split(":", aws_db_instance.mysql_db.endpoint)[0]
}