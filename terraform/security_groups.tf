# Web server SG
resource "aws_security_group" "mern_web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Web server: SSH from my IP, HTTP from anywhere"
  vpc_id      = aws_vpc.mern_vpc.id

  # SSH only from your laptop's IP (set in terraform.tfvars)
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # port 80
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound 
  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 = all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}

#  DB server SG 
resource "aws_security_group" "mern_db_sg" {
  name        = "${var.project_name}-db-sg"
  description = "DB server: MongoDB and SSH only from the web server"
  vpc_id      = aws_vpc.mern_vpc.id

  ingress {
    description     = "MongoDB from web server"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.mern_web_sg.id]
  }

  # SSH only via the web server
  ingress {
    description     = "SSH from web server (bastion)"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.mern_web_sg.id]
  }

  # Outbound 
  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-db-sg"
  }
}
