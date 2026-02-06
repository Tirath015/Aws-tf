terraform {
  
}

#number list
variable "num_list" {
    type = list(number)
    default = [1,2,3,4,5]
}




#object list of persons
variable "persons" {
    type = list(object({
      name = string
      age  = number
    }))
    default = [
      {
        name = "Alice"
        age  = 30
      },
      {
        name = "Bob"
        age  = 25
      }
    ]
}

#map is similar to dictionary in python
variable "map_list" {
    type=map(list(number))
    default = {
      "key1" = [1,2,3]
      "key2" = [4,5,6]
    }
}


#calculation using expressions
locals {
  mul=2*2
  add=2+2
  equality= 2==2
}


output "output" {
    value={
      multiplication = local.mul
      addition       = local.add
      is_equal      = local.equality# will return true or false
      var_num_list  = var.num_list

      #double the list values
      doubled = [for num in var.num_list : num * 2]
      # only odd numbers from the list
      odd_numbers = [for num in var.num_list : num if num % 2 != 0]

      var_persons   = var.persons
      #only get the first names from the persons object list
      names = [for person in var.persons : person.name]
      #only get persons older than 26
      older=[for person in var.persons: person if person.age>26 ]

      var_map_list  = var.map_list
      # i only want key1
      only_key1 = [for k, v in var.map_list :key ]
      #double the values 
      double=[for k,v in var.map_list:values*2]

      #so it is going to print like key1=[2,4,6] key2=[8,10,12]
      double_value={ for k,v in var.map_list : k =>  values*2 }

      
    
    }
  
}