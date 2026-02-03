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

resource "aws_s3_bucket" "mywebapp" { # here we are using the s3 bucket and naming it mybucket

    bucket = "my-unique-bucket-name-${random_id.rand_id.hex}" # this is for the bucket name which should be unique across all aws users  and the random id will generate the random password in this bucket 

    tags = {
        Name        = "MyFirstBucket" # this is for the naming of the bucket
        Environment = "Dev"
    }
  
}   

#now to enable the static website hosting on the s3 bucket we have to add the below code and take this one code from the terraform documentation aws_s3_bucket_public_access_block

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mywebapp.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


#now for this one enabled public ip i need to give the policy to the bucket so that everyone can access it  so for that we will create a policy
resource "aws_s3_bucket_policy" "Mypolicy" {
    bucket =  aws_s3_bucket.mywebapp.id
    policy=jsonencode(
        {
            #to get this code go to the aws official documentation for the s3 bucket policy and then you can generate the policy by giving the bucket name
            #remember you need to make some of the changes like removing the double quotes from the values and keys and also you need to remove : and add = sign
    Version="2012-10-17",		 	 	 
    Statement= [
        {
            Sid= "PublicReadGetObject",
            Effect= "Allow",
            Principal= "*",
            Action= "s3:GetObject"
            Resource="arn:aws:s3:::${aws_s3_bucket.mywebapp.id}/*"
            
        }
    ]
}
    )
}

#now to generate the url for the static website hosting i need the code below and take this code from the terraform documentation  aws_s3_bucket_website_configuration
resource "aws_s3_bucket_website_configuration" "app" {
  bucket = aws_s3_bucket.mywebapp.id

  index_document {
    suffix = "index.html"
  }

}





resource "aws_s3_object" "index" { # this resourse we have created to upload the object in the s3 bucjet
  source = "index.html"  # so this is my source file which i want to upload in the s3 bucket
  bucket = aws_s3_bucket.mywebapp.bucket# so this is the s3 bucket in whhich i want to upload the file
  key    = "index.html"#  so this is the txt file under the s3 in which i am copying the file
  content_type = "text/html" # so this will show me the website in the html format
}

resource "aws_s3_object" "styles" { # this resourse we have created to upload the object in the s3 bucjet
  source = "styles.css"  # so this is my source file which i want to upload in the s3 bucket
  bucket = aws_s3_bucket.mywebapp.bucket# so this is the s3 bucket in whhich i want to upload the file
  key    = "styles.css"#  so this is the txt file under the s3 in which i am copying the file
  content_type = "text/css"# so this will show me the website in the css format
}



output "Check_endpoint_created" {
    description = "This output will show mw the endpoint created on the terminal for the static website hosting"
    value       = aws_s3_bucket_website_configuration.app.website_endpoint # this will give me the random id generated when it is created on the terminal
  
}