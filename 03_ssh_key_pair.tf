
################## SSH key generation ################## 
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

################## Extracting private key ################## 
resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = var.private_key_location
  file_permission = "0400"
}

################## Create AWS key pair ################## 
resource "aws_key_pair" "deployer_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh.public_key_openssh
}