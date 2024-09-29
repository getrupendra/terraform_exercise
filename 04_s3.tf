resource "aws_s3_bucket" "my_bucket" {
  bucket = "rsoni89068-bucket"

  tags = {
    Name = "rsoniBucket"
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_s3_access_role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3-access-policy"
  description = "Allows EC2 instances to access the S3 bucket"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:ListBucket"
        ],
        "Resource": [
          "${aws_s3_bucket.my_bucket.arn}"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Resource": [
          "${aws_s3_bucket.my_bucket.arn}/*"
        ]
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "ec2_s3_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

output "bucket_name" {
  value = aws_s3_bucket.my_bucket.id
}

output "print_s3_commands" {
    value =  <<COMMENT
        run following commands inside EC2 to test S3:
        aws s3 cp <any_file_in_ec2_instance> s3://${aws_s3_bucket.my_bucket.id} 
        aws s3 ls s3://${aws_s3_bucket.my_bucket.id} 
    COMMENT
}