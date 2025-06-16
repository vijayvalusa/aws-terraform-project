output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "web_subnet_ids" {
  description = "IDs of subnets with Role = web"
  value = [
    for subnet in aws_subnet.public :
    subnet.id if subnet.tags["Role"] == "web"
  ]
}

output "app_subnet_ids" {
  description = "IDs of subnets with Role = app"
  value = [
    for subnet in aws_subnet.private :
    subnet.id if subnet.tags["Role"] == "app"
  ]
}

output "db_subnet_ids" {
  description = "IDs of subnets with Role = db"
  value = [
    for subnet in aws_subnet.private :
    subnet.id if subnet.tags["Role"] == "db"
  ]
}