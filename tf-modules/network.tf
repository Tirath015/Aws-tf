provider "aws" {
    region = "eu-west-1"  # here we are calling the variable region which we have defined above
  
}

data "aws_availability_zone" "name" {
    state = "available" # this will give me all the available zones in the particular region    )
  
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zone.name.names   
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  tags={
    Name = "my-vpc"
  }


}

# it will just go to the path and do every thing based on the module which is also provided by the aws on terraform modeule
