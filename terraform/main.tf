#Configure the AWS Provider
provider "aws" {
        region = "eu-central-1"
}
#Finding Ubuntu image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
#Creating instance ec2
resource "aws_instance" "ec2_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "devops-netology"
  }
}

data "aws_caller_identity" "current" {}

#defined in outputs.tf
#output "account_id" {
#  value = data.aws_caller_identity.current.account_id
#}

data "aws_region" "current" {}

