terraform {
  backend "s3" {
    bucket = "terraform-v-os"
    key    = "tfstate.json"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.55"
    }
  }

  required_version = ">= 1.7.0"
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"  # Change if you want to use another AWS account profile
}

# Security Group for Netflix App
resource "aws_security_group" "netflix_app_sg" {
  name        = "terraform_sg-netflix-app-sg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows SSH access from any IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows HTTP access from any IP
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows access to port 3000 from any IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"           # Allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance for Netflix App
resource "aws_instance" "netflix_app" {
  ami                    = "ami-0ddc798b3f1a5117e"
  instance_type          = "t2.micro"
  security_groups        = [aws_security_group.netflix_app_sg.name]
  user_data              = file("/home/omersade/Terraform/deploy.sh")

  tags = {
    Name = "netflix"
    Env  = "dev"
  }
}

