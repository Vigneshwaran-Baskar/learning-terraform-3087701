data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.app_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [module.web_sg.security_group_id]

  tags = {
    Name = "Learning Terraform"
  }
}

module "web_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"
  name  = "web_new"

  vpc_id = data.aws_vpc.default.id
  ingress_rules=["http-80-tcp","https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules=["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group" "web" {
  name = "web"
  tags = {
    Terraform = "true"
  }
  vpc_id = data.aws_vpc.default.id
}

