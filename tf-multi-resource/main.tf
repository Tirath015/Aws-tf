terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

locals {
  project="project-01"
}

provider "aws" {  # this is for the highlevel aws provider
  
    region = "us-east-1"  # here we are calling the variable region which we have defined above
}

resource "aws_vpc" "myvpc" {

    cidr_block = "10.0.${count.index}.0/16"# so for this one we have 10.0.0.0/16 and for the second one we have 10.0.1.0/16 so incremented by one 
    tags = {
      Name = "${local.project}"-"vpc"
    }
  
}


resource "aws_subnet" "name" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    count = 2# now the count will create 2 subnets with the same cidr block but different availability zones
    tags={
      #now subnets will have different names based on the count index
    Name = "${local.project}"-"subnet-${count.index + 1}"# this will give the name as project-01-subnet-1 and project-01-subnet-2
    }
  
}


#creating four ec2 instaces and subnet 1 have two instances and subnet 2 have two instances so total four instances will be created with the same ami and instance type but different availability zones  
resource "aws_instance" "main" {
    ami = "ami-0c94855ba95c71c99" # this is the ami id for the amazon linux 2 in us-east-1 region
    instance_type = "t2.micro"
    count = 4 # this will create 4 instances with the same ami and instance type but different availability zones
    #0%2=0
    #1%2=1
    #2%2=0
    #3%2=1
#so modulus will now run as per the lenght of the subnet list which is 2 so it will assign the subnet id to the instances in a round robin manner so that two instances will be in subnet 1 and two instances will be in subnet 2 
    subnet_id = element(aws_subnet.name.*.id, count.index % length(aws_subnet.name)) # this will assign the subnet id to the instances in a round robin manner so that two instances will be in subnet 1 and two instances will be in subnet 2  
    tags={
      Name = "${local.project}"-"instance-${count.index + 1}"# this will give the name as project-01-instance-1, project-01-instance-2, project-01-instance-3 and project-01-instance-4
    }
}


# now create 2 ec2 instace onw with the ubuntu ami and other with the amazon linux 2 ami and both will be in the same subnet so that we can test the connectivity between them using ping command
resource "aws_instance" "main" {

  count = length(var.ec2-config) # this will create instances based on the length of the list of objects in the variable so for this one we have 2 objects in the list so it will create 2 instances
  # now i am using the values in the variables and i have stored the values in tfvars and now i am retrieving the values from the variables and using them in the resource block so that i can create multiple instances with different configurations using the same resource block and the count index will help me to retrieve the values from the list of objects in the variable
  ami=var.ec2-config[count.index].ami # this will take the ami from the variable which we have defined in the terraform.tfvars file and it will take the ami based on the count index so for the first instance it will take the first ami and for the second instance it will take the second ami
  instance_type=var.ec2-config[count.index].instance_type # this will take the instance

  subnet_id = element(aws_subnet.name.*.id, count.index % length(aws_subnet.name)) # this will assign the subnet id to the instances in a round robin manner so that two instances will be in subnet 1 and two instances will be in subnet 2  
    tags={
      Name = "${local.project}"-"instance-${count.index + 1}"# this will give the name as project-01-instance-1, project-01-instance-2, project-01-instance-3 and project-01-instance-4
    }
}

#now doing it using the for_each loop and for this one we will be using the map variable which we have defined in the variables.tf file and we will be using the key of the map variable to create the instances and the values of the map variable will be used to create the instances with different configurations so that we can test the connectivity between them using ping command
resource "aws_instance" "main" {# this will run based on the variables in the tfvars if there are two then it will be running twp times and based on numbers it will run

  for_each = var.map_list # this will create instances based on the keys of the map variable so for this one we have 2 keys in the map variable so it will create 2 instances
  ami=each.value.ami # this will take the ami from the map variable which we have defined in the terraform.tfvars file and it will take the ami based on the key of the map variable so for the first instance it will take the first ami and for the second instance it will take the second ami
  instance_type=each.value.instance_type # this will take the instance type from the map variable
  
  subnet_id = element(aws_subnet.name.*.id, index(keys(var.map_list), each.key) % length(aws_subnet.name)  ) # this will assign the subnet id to the instances in a round robin manner so that two instances will be in subnet 1 and two instances will be in subnet 2  
   
    tags={
      Name = "${local.project}"-"instance-${each.key}"# this will give the name as project-01-instance-Ubuntu and project-01-instance-Amazon based on the keys of the map variable  
      }
}

output "subnet " {
  value = aws_subnet.name[0].id # this will give the list of subnet ids created by the count  we can not directly access the subnet id because it is a list so we have to specify the index of the subnet we want to access
  
}