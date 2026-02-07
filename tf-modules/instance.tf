module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.2.0"


   name = "single-instance"

  instance_type = "t3.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id] # this will attach the default security group of the vpc to the ec2 instance so that we can access the ec2 instance from the internet and also we can access the ec2 instance from the other instances in the same vpc
  subnet_id     = module.vpc.public-subnets[0] # this will launch the ec2 instance in the first public subnet of the vpc which we have created using the module and also we can access the ec2 instance from the internet because it is in the public subnet and it has the default security group attached to it which allows all the traffic from the internet to the ec2 instance and also allows all the traffic from the other instances in the same vpc to the ec2 instance
  ami           = "ami-0c55b159cbfafe1f0" # this is for the ami id which we can get from the aws dashboard
  tags = {
    Name= "single-instance"
    Terraform   = "true"
    Environment = "dev"
  }
}  # after adding modeules do terraform init to download the module and then do terraform apply to create the resources in aws based on the module which we have added here and also based on the configuration which we have provided in the module which is in the tf-modules/instance.tf file    





