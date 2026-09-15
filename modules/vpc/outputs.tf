output "vpc_id" {
    description = "The main VPC identifier"
    value = aws_vpc.main.id
  
}

output "public_subnet_ids" {
    description = "A list of the public subnet identifiers"
    value = [
        aws_subnet.public-a.id,
        aws_subnet.public-b.id
    ]
  
}

output "app_private_subnet_ids" {
    description = "A list of the private application subnet identifiers"
    value = [
        aws_subnet.private-a-app.id,
        aws_subnet.private-b-app.id
    ]
  
}

output "db_private_subnet_ids" {
    description = "A list of the private database subnet identifiers"
    value = [
        aws_subnet.private-a-db.id,
        aws_subnet.private-b-db.id
    ]
  
}