#now i have so many things so i made the object and in the object i have the list of thing which i need for the particukar instance

variable "ec2-config" {
    type=list(object({
      ami = string
      instance_type = string
    }))

  
}


#now for the mapand for this one i will be using the for_each
variable "map_list" {
    #key=value 
    type=map(object({
      ami = string
      instance_type = string
    }))
}