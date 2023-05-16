terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.29"
    }
  }

}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

provider "aws" {
  region = "ap-southeast-1"
  alias  = "singapore"
}

data "aws_db_instance" "database" {
  provider               = aws.singapore
  db_instance_identifier = var.rds_name
}


resource "aws_instance" "frontend" {
  count    = var.instance_count
  provider = aws.singapore

  ami                     = var.ami
  instance_type           = var.instance_type
  key_name                = var.key_name
  vpc_security_group_ids  = [aws_security_group.frontend.id]
  disable_api_termination = var.disable_api_termination
  tags                    = var.tags
  user_data               = file("${path.module}/scripts/install_devopsdemoapp.sh")

  depends_on = [
    aws_key_pair.terraform
  ]

  lifecycle {
    prevent_destroy = false
  }

  timeouts {
    create = "7m"
    delete = "1h"
  }
}


resource "aws_key_pair" "terraform" {
  provider = aws.singapore

  key_name   = var.aws_key_pair.name
  public_key = var.aws_key_pair.public_key
}


resource "aws_security_group" "frontend" {
  provider = aws.singapore

  name        = "frontend"
  description = "Open ports for Frontend Web App"

  ingress {
    description = "SSH from Anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from Anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow ALL Outgoing"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : "Frontend Web App"
  }
}
