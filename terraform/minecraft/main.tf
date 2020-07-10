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
