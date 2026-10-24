variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1" # Default region if not specified

}


variable "project_name" {
  description = "The name of the project for tagging and identification"
  type        = string
  default     = "travelmemory" # Default project name if not specified
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"

}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "t2.micro"
}

variable "my_ip" {
  description = "Your public IP address for SSH access (in CIDR notation)"
  type        = string

}

variable "key_name" {
  description = "The name of the SSH key pair to use for EC2 instances"
  type        = string
  default     = "mern-key" # Default key pair name if not specified
}


variable "public_key_path" {
  description = "Path to the SSH public key uploaded to AWS"
  type        = string
  default     = "~/.ssh/mern-key.pub"
}

variable "availability_zone" {
  description = "The availability zone to deploy resources"
  type        = string
  default     = "us-east-1a" # Default availability zone if not specified
}
