resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
      Name = "terraform-example"
  }
}

resource "aws_subnet" "subnet_1" {
  cidr_block = "${cidrsubnet(aws_vpc.example.cidr_block, 3, 1)}"
  vpc_id = "${aws_vpc.example.id}"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_2" {
  cidr_block = "${cidrsubnet(aws_vpc.example.cidr_block, 2, 2)}"
  vpc_id = "${aws_vpc.example.id}"
  availability_zone = "us-east-1b"
}
