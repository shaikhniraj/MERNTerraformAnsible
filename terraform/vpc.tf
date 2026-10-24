resource "aws_vpc" "mern_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "mern_public_subnet" {
  vpc_id                  = aws_vpc.mern_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone # Specify the availability zone
  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

resource "aws_subnet" "mern_private_subnet" {
  vpc_id            = aws_vpc.mern_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone # Specify the availability zone   
  tags = {
    Name = "${var.project_name}-private-subnet"
  }
}


resource "aws_internet_gateway" "mern_igw" {
  vpc_id = aws_vpc.mern_vpc.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_eip" "mern_eip" {
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-eip"
  }
}

resource "aws_route_table" "mern_public_rt" {
  vpc_id = aws_vpc.mern_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mern_igw.id
  }
  tags = {
    Name = "${var.project_name}-public-rt"
  }
}
resource "aws_route_table_association" "mern_public_rt_assoc" {
  subnet_id      = aws_subnet.mern_public_subnet.id
  route_table_id = aws_route_table.mern_public_rt.id
}

resource "aws_route_table" "mern_private_rt" {
  vpc_id = aws_vpc.mern_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mern_nat_gw.id
  }
  tags = {
    Name = "${var.project_name}-private-rt"
  }
}


resource "aws_route_table_association" "mern_private_rt_assoc" {
  subnet_id      = aws_subnet.mern_private_subnet.id
  route_table_id = aws_route_table.mern_private_rt.id
}

resource "aws_nat_gateway" "mern_nat_gw" {
  allocation_id = aws_eip.mern_eip.id
  subnet_id     = aws_subnet.mern_public_subnet.id
  depends_on    = [aws_internet_gateway.mern_igw]
  tags = {
    Name = "${var.project_name}-nat-gw"
  }
}


