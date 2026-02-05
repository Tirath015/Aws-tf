terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

provider "aws" {  # this is for the highlevel aws provider
  
    region = "us-east-1" # here we are calling the variable region which we have defined above
}

locals {
  owners="ABC"
  name="sample server"
}


resource "aws_instance" "myserver" {


    ami           = "ami-0c55b159cbfafe1f0" 
    instance_type = var.instance_type


    root_block_device {
      delete_on_termination = true
      volume_size = var.ec2.volume_size
      volume_type = var.ec2.volume_type# i can use the variable for volume type
    }
    tags = merge(var.additional_tags, {
      Name = local.name
      Owner = local.owners# i can use local values as well here
    } )
      

  
}