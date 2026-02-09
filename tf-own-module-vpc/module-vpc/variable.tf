variable "vpc_config" {

    description = "Configuration for the VPC taking cidr block and name"
    type=object({
        cidr_block       = string
        name            = string

    })

    validation {
      condition = can(cidrnetmask(var.vpc_config.cidr_block))
        error_message = "The cidr_block must be a valid CIDR notation. -${var.vpc_config.cidr_block}"
    }
  
}


variable "subnet_config" {
    #sub 1={cidrr-.., az-..}  sub2{cidrr-.., az-..  }
    description = "get the az and cidr block for the subnet "
    type=map(object({
        cidr_block       = string
        availability_zone= string
        public=optional(bool,false)  # this is for the public subnet and private subnet if the public is true then it is going to create the public subnet otherwise it is going to create the private subnet and the default is false means it is private subnet 
    }))

     #sub 1={cidrr-.., az-..}  sub2{cidrr-.., az-..  },[true,false,true]  if all the conditions is right then only it will work otherwise it is going to give me the errors 
     validation {
      condition = alltrue([for subnet in values(var.subnet_config) : can(cidrnetmask(subnet.cidr_block))])
        error_message = "The cidr_block must be a valid CIDR notation. -${var.vpc_config.cidr_block}"
    }
  
}



