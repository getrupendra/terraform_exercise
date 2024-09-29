data "aws_ami" "amazon_linux_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"
    values = [
      "amzn2-ami-kernel-*-hvm-*-x86_64-gp2"
    ]
  }
}

data "local_file" "efs_tpl" {
  filename = "./efs_mount.tpl"
}