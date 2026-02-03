terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }

  }

  backend "s3" {
    bucket = "my-unique-bucket-name-1234" # replace with your S3 bucket name so this name should be of the created bucket in s3
    key    = "terraform.txt" # in my s3 bucket to which file i want to store the state 
    region = "eu-west-1" # replace with your S3 bucket region
    
  }
}

provider "aws" {  # this is for the highlevel aws provider
  
    region = "eu-west-1" # here we are calling the variable region which we have defined above
}


resource "aws_instance" "myserver" {# so the option number 1 is to use which resourse s3, ec2 and the second option is for naming that so here we are using the ec2 and i have named it myserver
#in this block mention all the resourses like aws ami , instance type 


    ami           = "ami-0c55b159cbfafe1f0" # this is for the ami id which we can get from the aws dashboard
    instance_type = "t2.micro" # this is for the instance type which we can get from the aws dashboard

    tags = {
        Name = "MyFirstServer" # this is for the naming of the instance
    }
  
}