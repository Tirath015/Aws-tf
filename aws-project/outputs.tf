output "aws_instace_id_public_ip" {
    description = "The public IP address of the EC2 instance"
    value       = aws_instance.ngnix.public_ip# this will give me the ip adress of the instance when it is created on the trerminal
  
}


output "instance_url" {
    description = "The public URL of the EC2 instance"
    value       = "http://${aws_instance.ngnix.public_ip}" # this will give me the URL of the instance when it is created on the terminal
  
}