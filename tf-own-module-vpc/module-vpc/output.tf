output "Vpc_id" {
    value = aws_vpc.name.id
}
# to format the subnet id in the format of subnet{id,name etc}
locals{
    public_subnet_details    = {
       for key,config in local.public_subnet : key => {
        subnet_id=aws_subnet.subnet_config[key].id
        availability_zone=aws_subnet.subnet_config[key].availability_zone

       }

     


}
private_subnet   = {
       for key,config in local.private_subnet : key => {
        subnet_id=aws_subnet.subnet_config[key].id
        availability_zone=aws_subnet.subnet_config[key].availability_zone

       }

    }
}

#subnet details
output "public-subnets" {
    value = local.public_subnet_details
    
    }



output "private_subnets" {
    value = local.private_subnet
  
}