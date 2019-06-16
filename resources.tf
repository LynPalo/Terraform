resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "terraform-example"
  }
}

resource "aws_subnet" "subnet_1" {
  cidr_block        = "${cidrsubnet(aws_vpc.example.cidr_block, 3, 1)}"
  vpc_id            = "${aws_vpc.example.id}"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_2" {
  cidr_block        = "${cidrsubnet(aws_vpc.example.cidr_block, 2, 2)}"
  vpc_id            = "${aws_vpc.example.id}"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "subnet_security_group" {
  vpc_id = "${aws_vpc.example.id}"

  ingress {
    cidr_blocks = ["${aws_vpc.example.cidr_block}"]

    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
      name = "virtualization-type"
      values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "server_2" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "t2.micro"

    tags {
        Name = "ec2"
    }
  subnet_id = "${aws_subnet.subnet_1.id}"
}


