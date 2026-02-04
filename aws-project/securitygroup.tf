resource "aws_security_group" "nginx-sg" {
    vpc_id = aws_vpc.myvpc.id # linking the security group to the vpc
    #inbound rule
    ingress{
        from_port   = 80 
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # allowing access from anywhere
    

    }


    # outbound rule
    egress{
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"] # allowing all outbound traffic


    }

    tags = {
        Name = "nginx-security-group"
        }   
  
}