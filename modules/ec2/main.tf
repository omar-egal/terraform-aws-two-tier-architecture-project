data "aws_ec2_instance_type" "t2micro" {
  instance_type = "t2.micro"
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true


  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "web-1" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = data.aws_ec2_instance_type.t2micro.instance_type
  vpc_security_group_ids = module.security.pub_sg_id

  tags = {
    Name = "TerraformWebServer"
  }
}

