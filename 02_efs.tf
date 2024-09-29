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

################## Generating Script for Mounting EFS ################## 
resource "null_resource" "generate_efs_mount_script" {

  provisioner "local-exec" {
    command = templatefile(data.local_file.efs_tpl.filename, {
      efs_mount_point = var.efs_mount_point
      file_system_id  = aws_efs_file_system.file_system_1.id
    })
    interpreter = [
      "bash",
      "-c"
    ]
  }

  triggers = {
    file_changed = md5(data.local_file.efs_tpl.content) # Trigger this only once, based on change on efs_mount.tpl
  }
}

output "aws_efs_file_system_name" {
  value = aws_efs_file_system.file_system_1.name
}