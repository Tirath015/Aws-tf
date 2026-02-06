ec2-config = [ {
  ami="ubuntu"
  instance_type = "t2.micro"
},
{
  ami="amazon"
  instance_type = "t2.micro"
}
]

map_list = {
  "Ubuntu" = {
    ami = "ubuntu"
    instance_type = "t2.micro"
  },
  "Amazon" = {
    ami = "amazon"
    instance_type = "t2.micro"  
  }
}