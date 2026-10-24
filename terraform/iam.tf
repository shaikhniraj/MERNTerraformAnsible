# An IAM role gives the EC2 instances permissions WITHOUT storing access keys on them.

# 1. The role + trust policy: "who is allowed to assume this role?" -> the EC2 service
resource "aws_iam_role" "mern_ec2_role" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ec2-role"
  }
}

# 2. Permissions: SSM lets you open a shell from the AWS console (Session Manager)
#    even without SSH, which is a handy backup if you lock yourself out during hardening.
resource "aws_iam_role_policy_attachment" "mern_ssm" {
  role       = aws_iam_role.mern_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Lets the instances push logs/metrics to CloudWatch if you install the agent later
resource "aws_iam_role_policy_attachment" "mern_cloudwatch" {
  role       = aws_iam_role.mern_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# 3. Instance profile: the "container" that attaches a role to an EC2 instance
resource "aws_iam_instance_profile" "mern_ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.mern_ec2_role.name
}
