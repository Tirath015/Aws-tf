resource "aws_vpc" "name" {
    cidr_block = var.vpc_config.cidr_block

    tags = {
        Name = var.vpc_config.name
    }
  
}


resource "aws_subnet" "subnet_config" {

    # so when i have the map type variable i have to use the for each loop
    for_each = var.subnet_config  #key= sub1, sub2  value = {cidr-.., az-..  }  each.value, each.key

    vpc_id            = aws_vpc.name.id
    cidr_block       = each.value.cidr_block
    availability_zone= each.value.availability_zone

    tags = {
        Name = "${var.vpc_config.name}-subnet-${each.key}"
    }
  
}

locals {
  public_subnet={
    #key={} if the public is true then it is going to create the public subnet otherwise it is going to create the private subnet and the default is false means it is private subnet
    for key,config in var.subnet_config : key => config if config.public 
  }

  private_subnet={
    #key={} if the public is false then it is going to create the private subnet otherwise it is going to create the public subnet and the default is false means it is private subnet
    for key,config in var.subnet_config : key => config if! config.public
  }
  }

#internet gateway if there is one public subnet
resource "aws_internet_gateway" "ig_gateway" {
    count = length(local.public_subnet) >0 ? 1 : 0  # if there is one public subnet then it is going to create the internet gateway otherwise it is not going to create the internet gateway because if there is no public subnet then there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need ofthe internet gateway because we cannot accessthe private subnetfromtheinternetandalsowecannotaccesstheprivatesubnetfromtheotherinstancesinthesamevpcbecausethereisnoneedofinternetgatewaybecausewecannotaccesstheprivatesubnetfromtheinternetandalsowecannotaccesstheprivatesubnetfromtheotherinstancesinthesamevpcbecausethereisnoneedofinternetgatewaybecausewecannotaccesstheprivates

    vpc_id = aws_vpc.name.id

    tags = {
        Name = "${var.vpc_config.name}-igw"
    }   

  
}

#route table for public subnet if there is one public subnet
resource "aws_route_table" "route_table" {
    count = length(local.public_subnet) >0 ? 1 : 0  # if there is one public subnet then it is going to create the internet gateway otherwise it is not going to create the internet gateway because if there is no public subnet then there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need of the internet gateway because we cannot access the private subnet from the internet and also we cannot access the private subnet from the other instances in the same vpc because there is no need ofthe internet gateway because we cannot accessthe private subnetfromtheinternetandalsowecannotaccesstheprivatesubnetfromtheotherinstancesinthesamevpcbecausethereisnoneedofinternetgatewaybecausewecannotaccesstheprivatesubnetfromtheinternetandalsowecannotaccesstheprivatesubnetfromtheotherinstancesinthesamevpcbecausethereisnoneedofinternetgatewaybecausewecannotaccesstheprivates

    vpc_id = aws_vpc.name.id

    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ig_gateway[0].id
    }

  
}


#associate the route table with the public subnet if there is one public subnet
resource "aws_route_table_association" "route_table_association" {
    for_each = local.public_subnet  #key= sub1, sub2  value = {cidr-.., az-..  }  each.value, each.key
    subnet_id = aws_subnet.subnet_config[each.key].id
    route_table_id = aws_route_table.route_table[0].id
}