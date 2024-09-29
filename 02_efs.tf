################## Create EFS File system ################ 
resource "aws_efs_file_system" "file_system_1" {
  creation_token = "my-efs"

  tags = {
    Name = "my-efs"
  }
}


################## Create EFS mount targets ################ 
resource "aws_efs_mount_target" "mount_targets" {
  file_system_id  = aws_efs_file_system.file_system_1.id
  subnet_id       = aws_subnet.public_subnet_1.id
  security_groups = [aws_security_group.efs_sg.id]
}


output "aws_efs_file_system_name" {
  value = aws_efs_file_system.file_system_1.id
}