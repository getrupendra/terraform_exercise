
# Create a security group for the EC2 instance
resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.my_vpc.id

  name = "allow SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-ssh-sg"
  }
}

# Create a security group for EFS

resource "aws_security_group" "efs_sg" {
  name        = "allow_from_public_instances"
  description = "Allow traffic from public instance sg only"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.instance_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "efs_sg"
  }
}

output "allow_ssh_security_group_id" {
  value = aws_security_group.instance_sg.id
}

output "allow_ssh_security_group_name" {
  value = aws_security_group.instance_sg.name
}

output "allow_efs_security_group_name" {
  value = aws_security_group.efs_sg.name
}

output "allow_efs_security_group_id" {
  value = aws_security_group.efs_sg.id
}

resource "aws_instance" "my_instance" {
  ami                  = data.aws_ami.amazon_linux_ami.id
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.public_subnet_1.id
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  key_name               = aws_key_pair.deployer_key.key_name
  tags = {
    Name = "test_netspi_vm"
  }

  depends_on = [
    aws_efs_mount_target.mount_targets
  ]

  user_data = <<-EOF
              #!/bin/bash
              yum install -y amazon-efs-utils aws-cli
              mkdir -p ${var.efs_mount_point}
              sudo mount -t efs -o tls ${aws_efs_file_system.file_system_1.id}:/ ${var.efs_mount_point}
              sudo echo "${aws_efs_file_system.file_system_1.id}:/ ${var.efs_mount_point} efs defaults,_netdev 0 0" >> /etc/fstab
              sudo chown -R ec2-user:ec2-user ${var.efs_mount_point}
              EOF
}

output "ec2_name" {
  value       = aws_instance.my_instance.id
  description = "Name of EC2 instance"
}

output "print_ssh_command" {
  value = "To connect, run : 'ssh -i ${var.private_key_location} ec2-user@${aws_eip.eip.public_ip}'"
}


