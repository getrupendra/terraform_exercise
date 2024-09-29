# Elastic IP
resource "aws_eip" "eip" {
  instance = aws_instance.my_instance.id

  tags = {
    Name = "MyElasticIP"
  }
}

# Output the public IP of the Elastic IP
output "elastic_ip" {
  description = "EIP address for  the EC2 instance"
  value       = aws_eip.eip.public_ip
}