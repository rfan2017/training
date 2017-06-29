#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-2378f540
#
# Your subnet ID is:
#
#     subnet-fdf3c88b
#
# Your security group ID is:
#
#     sg-67393600
#
# Your Identity is:
#
#     datapipe-tuna
#

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

variable "num_webs" {
  default = "2"
}

resource "aws_instance" "web" {
  ami                    = "ami-2378f540"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-fdf3c88b"
  vpc_security_group_ids = ["sg-67393600"]
  count                  = "${var.num_webs}"

  tags {
    Identity = "datapipe-tuna"
    Name     = "web ${count.index+1}/${var.num_webs}"
  }
}

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  type    = "string"
  default = "ap-southeast-1"
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}

terraform {
  backend "atlas" {
    name = "datapiperfan/training"
  }
}
