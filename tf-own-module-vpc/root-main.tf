provider "aws" {
  region = "eu-west-1   "  # here we are calling the variable region which we have defined above
}

module "VPC" {
    source = "./module-vpc"
    vpc_config = {
        cidr_block = "10.0.0.0/16"
        name       = "my-own-vpc"
}
       subnet_config = {
       public_subnet={
        cidr_block="10.0.1.0/24 "
        availability_zone="eu-west-1a"
        public=true
       }


       public_subnet_2={
        cidr_block="10.0.2.0/24 "
        availability_zone="eu-west-1b"
        public=true
       }


         private_subnet={
          cidr_block="10.0.3.0/24   "
          availability_zone="eu-west-1c"
}

         

}

}





# so this is the main file or the root file where we are calling the module which we have created in the module vpc folder and passing the values to the variable which we have defined in the variable.tf file in the module vpc folder


# so the main .tf is the file where we are creating the provider and calling the module and passing the values to the variable which we have defined in the variable.tf file in the module vpc folder