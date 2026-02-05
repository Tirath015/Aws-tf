variable "instance_type" {
    description = "what ype of instance you want to launch  "  
    type        = string
    #validation like if and else condition in programming laguages
    validation {
        condition = var.instance_type=="t2.micro" || var.instance_type=="t3.micro"
        error_message = "only t2.micro and t3.micro instance types are allowed  "

      
    }
}

#so when i am going to launch an instance i will use this variable to define the instance type then the person will define the value in this 


#variable "volume_size" {
    #description = "Size of the root volume in GB"
    #type        = number
  
#}

#i can also define two variable in same block together using object type    
variable "ec2-config" {
    type=object({
      volume_size=number
      volume_type=string
    })
    default={
      volume_size=8
      volume_type="gp2"
    }
  
}


variable "additional_tags" {
    description = "A map of additional tags to add to all resources"
    type        = map(string)#expecting a map of key value pairs    
    default     = {}
  
}