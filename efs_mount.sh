#! /bin/bash
sudo yum update -y
sudo pip3 install botocore --upgrade
sudo mkdir -p /data/test
sudo yum -y install amazon-efs-utils
sudo su -c  "echo 'fs-057d14f95051eb9b2:/ /data/test efs _netdev,tls 0 0' >> /etc/fstab"
sudo mount -t efs -o tls fs-057d14f95051eb9b2:/ /data/test
df -k
sudo chown -R ec2-user:ec2-user /data/test


