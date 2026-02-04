#ec2 with the nginx server
resource "aws_instance" "ngnix" {


    ami           = "ami-0c55b159cbfafe1f0" 
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.mypublicsubnet.id # launching the ec2 instance in the public subnet
    vpc_security_group_ids = [aws_security_group.nginx-sg.id] # associating the security group with the ec2 instance
    associate_public_ip_address = true # associating a public IP address with the ec2 instance
    
    user_data     = <<-EOF
                    #!/bin/bash
        
                    sudo yum install nginx -y
                    sudo systemctl start nginx
                    sudo systemctl enable nginx
                    EOF
    tags = {
        Name = "ngnix" # this is for the naming of the instance
    }
  
}


