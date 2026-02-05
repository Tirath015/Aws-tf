terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

provider "aws" {  # this is for the highlevel aws provider
  
    region = "us-east-1 "  # here we are calling the variable region which we have defined above
}

data "aws_ami" "my_ami" {
  most_recent = true
  owners = ["137112412989"] # Amazon 
}


#security group
data "aws_security_group" "name" {
  tags={
   # myserver="http"# get the security group with the tag name http in the particualar region
    Name="nginx-security-group"
    ENV="PROD"
  }
}


#vpc
data "aws_vpc" "my_vpc" {
  tags ={
    ENV="PROD" # get the vpc with the tag name prod in the particular region
    Name="MyFirstVPC"
  }
}


#availability zones
data "aws_availability_zones" "available" {
  state = "available" # this will give me all the available zones in the particular region
}




#to get account information
data "aws_caller_identity" "name" {
  
}


#to get the region
data "aws_region" "current" {
  
}

#subnet id
data "aws_subnet" "my_subnet" {
  filter {
    #i need that subnet which is in the vpc id  
    name="vpc-id"
    values=[data.aws_vpc.my_vpc.id]
  }

  tags={
    Name="MyPublicSubnet"  #you can use the name of this subnet and then you can filter it using that name.
  }
}



#now i will launch an ec2 instance using the above data sources

resource "aws_instance" "myserver" {#

    ami           = "ami" # this is for the ami id which we can get from the aws dashboard
    instance_type = "t2.micro" # this is for the instance type which we can get from the aws dashboard
    subnet_id =   data.aws_subnet.my_subnet.id
    security_groups = [data.aws_security_group.name.id]
  
    tags = {
        Name = "MyFirstServer" # this is for the naming of the instance
    }
  
}

output "ami" {
  value = data.aws_ami.my_ami.name.id
  
}

output "security_group_id" {
  value = data.aws_security_group.name.id
  
}

output "vpc_id" {
  value = data.aws_vpc.my_vpc.id
  
}

output "availability_zones" {
  value = data.aws_availability_zones.available.names
  
}

output "account_id" {
  value = data.aws_caller_identity.name.account_id
  
}


output "region" {
  value = data.aws_region.current.name
  
}

output "subnet_id" {
  value = data.aws_subnet.my_subnet.id
  
}
