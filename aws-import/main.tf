terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

provider "aws" {  # this is for the highlevel aws provider
  
    region = "eu-west-1"  # here we are calling the variable region which we have defined above
}


resource "aws_s3_bucket" "s3_import" {
    # so we have the resourse created in the aws so we will be running the commnad 
    # terraform import aws_s3_bucket.s3_import mybucketname  # so this is the command to import the s3 bucket which we have created in the aws and then we will be running the command terraform plan to see the changes and then we will be running the command terraform apply to apply the changes
    bucket = "mybucketname" # this is for the bucket name which we have created in the aws and then we will be running the command terraform plan to see the changes and then we will be running the command terraform apply to apply the changes
}