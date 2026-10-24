# AMI lookup 
# A "data" block READS something that already exists (it creates nothing).
# This finds the latest official Ubuntu 22.04 image in whatever region you use,
# so there is no hard-coded, region-specific AMI ID.
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (publisher of Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#  SSH key pair 
# Uploads your PUBLIC key to AWS. The private key never leaves your laptop.
resource "aws_key_pair" "mern_key" {
  key_name   = var.key_name
  public_key = file(pathexpand(var.public_key_path)) # pathexpand turns ~ into your home dir
}

#  Web server (public subnet) 
resource "aws_instance" "mern_web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.mern_public_subnet.id
  vpc_security_group_ids = [aws_security_group.mern_web_sg.id]
  key_name               = aws_key_pair.mern_key.key_name
  iam_instance_profile   = aws_iam_instance_profile.mern_ec2_profile.name

  # Require IMDSv2 tokens for the metadata service
  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size = 10 # GB; node_modules + React build need some room
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "${var.project_name}-web"
    Role = "web"
  }
}

#  DB server (private subnet) 
resource "aws_instance" "mern_db" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.mern_private_subnet.id
  vpc_security_group_ids = [aws_security_group.mern_db_sg.id]
  key_name               = aws_key_pair.mern_key.key_name
  iam_instance_profile   = aws_iam_instance_profile.mern_ec2_profile.name

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
    encrypted   = true
  }

  depends_on = [aws_nat_gateway.mern_nat_gw, aws_route_table_association.mern_private_rt_assoc]

  tags = {
    Name = "${var.project_name}-db"
    Role = "db"
  }
}
