provider "aws" {
  region = "eu-west-2"
}

data "aws_ami" "minecraft_ami" {
  # go to aws console (website) -> ec2 -> find instance -> AMI ID -> find the AMI ID: the part in brackets e.g/ (ami-02xxxxxxxxxxx)
  # run (assuming its an aws-marketplace AMI):
  # aws ec2 describe-images --owners aws-marketplace
  # and grep the output for the AMI ID found earlier to find the below values to find the AMI
  owners = ["679593333241"]

  filter {
    name   = "image-id"
    values = ["ami-029d749da014117a2"]
  }
}

resource "aws_instance" "minecraft" {
  ami           = data.aws_ami.minecraft_ami.id
  instance_type = "t2.small"

  tags = {
    Name = "minecraft"
  }
}

resource "aws_security_group" "minecraft" {
  name   = "minecraft"
  description = "The security group for the minecrafter server machine"
  #id = "minecraft-security-group-id"
  #vpc_id = data.aws_vpc.default.id

  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    to_port   = 0
    security_groups = []
    protocol = "-1"
  }

  #ingress {
  #  cidr_blocks = [ "0.0.0.0/0" ]
  #  description = "The port minecraft server needs to allow players to connect"
  #  from_port = 25565
  #  to_port   = 25565
  #  protocol        = "TCP"
  #  security_groups = []
  #}

  #ingress {
  #  cidr_blocks = [ "0.0.0.0/0" ]
  #  description = "ssh"
  #  from_port = 22
  #  to_port   = 22
  #  protocol        = "TCP"
  #  security_groups = []
  #}
  #ingress {
  #  from_port = 22
  #  to_port   = 22
  #  protocol        = "TCP"
  #  security_groups = [data.aws_security_group.metabase_beanstalk_app_security_group.id]
  #}
  #ingress {
  #  from_port = 5432
  #  to_port   = 5432
  #  protocol        = "TCP"
  #  security_groups = [data.aws_security_group.metabase_beanstalk_app_security_group.id]
  #}
}

resource "aws_security_group_rule" "ssh" {
  type = "ingress"
    security_group_id = aws_security_group.minecraft.id
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "ssh"
    from_port = 22
    to_port   = 22
    protocol        = "TCP"
}

resource "aws_security_group_rule" "player_connections_to_minecraft_server" {
  type = "ingress"
  security_group_id = aws_security_group.minecraft.id
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "allow minecraft server connections"
  from_port = 25565
  to_port   = 25565
  protocol  = "TCP"
}

resource "aws_security_group_rule" "phoenix_dev" {
  type = "ingress"
  security_group_id = aws_security_group.minecraft.id
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "allow elixir phoenix dev on http"
  from_port = 4000
  to_port   = 4000
  protocol  = "TCP"
}

resource "aws_security_group_rule" "pings" {
  type = "ingress"
  security_group_id = aws_security_group.minecraft.id
  cidr_blocks = [ "0.0.0.0/0" ]
  description = "allow elixir phoenix dev on http"
  from_port = 8
  to_port   = -1
  protocol  = "icmp"
}
