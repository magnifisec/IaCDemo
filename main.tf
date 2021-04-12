terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "terraformtestec2" {
  ami = data.aws_ami.packertestami.id
  instance_type = "t2.micro"
  tags = {
    Name = "Terraform Test"
  }
}

data "aws_ami" "packertestami" {
  owners = ["self"]
  most_recent = true
  filter {
    name = "name"
    values = ["packertestami"]
  }
}
