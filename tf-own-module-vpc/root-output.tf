output "vpc" {
    value = aws_vpc.name.id
  
}

output "public_subnet" {
    value = module.VPC.public-subnets
  
}