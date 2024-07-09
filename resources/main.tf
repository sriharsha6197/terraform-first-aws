resource "aws_instance" "example-instance" {
  ami           = "ami-0b4f379183e5706b9"
  instance_type = "t2.micro"

  tags = {
    Name = "Example-instance"
  }
}

resource "aws_vpc" "use-this-vpc-for-example-instance" {
  cidr_block       = "10.40.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "use-this-vpc-for-example-instance"
  }
}

resource "aws_subnet" "use-this-vpc-subnet-for-example-instance" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.40.1.0/24"

  tags = {
    Name = "use-this-vpc-subnet-for-example-instance"
  }
}

resource "aws_internet_gateway" "igw-example-instance" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-example-instance"
  }
}