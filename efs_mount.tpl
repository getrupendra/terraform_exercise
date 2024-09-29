cat << EOF >> efs_mount.sh
#! /bin/bash
sudo yum update -y
sudo pip3 install botocore --upgrade
sudo mkdir -p ${efs_mount_point}
sudo yum -y install amazon-efs-utils
sudo su -c  "echo '${file_system_id}:/ ${efs_mount_point} efs _netdev,tls 0 0' >> /etc/fstab"
sudo mount -t efs -o tls ${file_system_id}:/ ${efs_mount_point}
df -k
sudo chown -R ec2-user:ec2-user ${efs_mount_point}


EOF