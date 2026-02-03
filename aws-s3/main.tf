terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }

    random = {
      source = "hashicorp/random"
      version = "3.8.1"
    }
  }
}

provider "aws" {  # this is for the highlevel aws provider
  
    region = "eu-west-1" # here we are calling the variable region which we have defined above
}


resource "random_id" "rand_id" {
    byte_length = 4 # this is for the byte length of the random id which we are generating

  
}

resource "aws_s3_bucket" "mybucket" { # here we are using the s3 bucket and naming it mybucket

    bucket = "my-unique-bucket-name-${random_id.rand_id.hex}" # this is for the bucket name which should be unique across all aws users  and the random id will generate the random password in this bucket 

    tags = {
        Name        = "MyFirstBucket" # this is for the naming of the bucket
        Environment = "Dev"
    }
  
}   


resource "aws_s3_object" "myobject" { # this resourse we have created to upload the object in the s3 bucjet
  source = "my-file.txt"  # so this is my source file which i want to upload in the s3 bucket
  bucket = aws_s3_bucket.mybucket.bucket# so this is the s3 bucket in whhich i want to upload the file
  key    = "my-object-key.txt"#  so this is the txt file under the s3 in which i am copying the file
}



output "Check_random_id_generated" {
    description = "This output will show the random id generated"
    value       = random_id.rand_id.hex # this will give me the random id generated when it is created on the terminal
  
}