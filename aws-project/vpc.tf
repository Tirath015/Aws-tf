#create a vpc
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "MyFirstVPC"
        }

}

#PRIVATE SUBNET
resource "aws_subnet" "myprivatesubnet" {

    cidr_block = "10.0.1.0/24  "
    vpc_id     = aws_vpc.myvpc.id# linking the vpc id to the subnet
    tags = {
        Name = "MyPrivateSubnet"
        }

}


#public SUBNET
resource "aws_subnet" "mypublicsubnet" {

    cidr_block = "10.0.2.0/24"
    vpc_id     = aws_vpc.myvpc.id# linking the vpc id to the subnet
    tags = {
        Name = "MyPublicSubnet"
        }
}



#internet gateway
resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.myvpc.id # linking the vpc id to the internet gateway
    tags = {
        Name = "MyInternetGateway"
        }
}


#routing table  
resource "aws_route_table" "myroutetable" {
    vpc_id = aws_vpc.myvpc.id # linking the vpc id to the routing table
    route{
        cidr_block = "0.0.0.0/0"# for all the traffic
        gateway_id = aws_internet_gateway.myigw.id# forward all the traffic to the internet gateway
    }
    tags = {
        Name = "MyRouteTable"
        }
}


#associating the public subnet with the routing table
resource "aws_route_table_association" "myroutetableassociation" {
    subnet_id      = aws_subnet.mypublicsubnet.id # linking the public subnet id to the routing table association
    route_table_id = aws_route_table.myroutetable.id # linking the routing table id to the routing table association
}  



#ec2 using this vpc
resource "aws_instance" "myserver" {


    ami           = "ami-0c55b159cbfafe1f0" 
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.mypublicsubnet.id # launching the ec2 instance in the public subnet
    tags = {
        Name = "MyFirstServer" # this is for the naming of the instance
    }
  
}