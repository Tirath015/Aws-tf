terraform {
  
}

locals {
  value="Hello World"

}

variable "String_list" {
    type = list(string)
    default = ["apple","banana","grape"]
  

}


output "output" {
    #value=lower(local.value)# this will convert the string to lower case
    #value=startswith(local.value,"Hello")# will return true or false wheter the string starts with Hello or not
   # value=length(local.value)# will return the length of the string
   # value =split(local.value," ")# will split the string based on space and return a list of strings
   #value=max(10,20,5,30,15)# will return the maximum value from the given numbers
  # value=abs(-13)# will return the absolute value means +13
  #value=length(var.String_list)# will return the length of the list
 # value=join(", ",var.String_list)# will join the list elements into a single string with comma and space as separator
 # value=contains(var.String_list,"banana")# will return true or false whether the list contains the value banana or not
  value=toset(var.String_list)# will convert the list to set and remove any duplicates if present
}