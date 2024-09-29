### Provisioning of AWS resources

An exercise to provision following resource in AWS:
1. VPC, Sbunets
2. EFS Volume and mount
3. Elastic IP and its association with EC2
3. EC2 and security groups
4. S3 bucket

To run, please export following terraform variables:
```
export TF_VAR_aws_access_key=<your aws access ID>
export TF_VAR_aws_secret_key=<your aws secret key>
export  TF_VAR_private_key_location  = "</path/to/store/privatekey/to/ssh_to_ec2>"
```

