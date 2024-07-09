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
  vpc_id     = aws_vpc.use-this-vpc-for-example-instance.id
  cidr_block = "10.40.1.0/24"

  tags = {
    Name = "use-this-vpc-subnet-for-example-instance"
  }
}

resource "aws_internet_gateway" "igw-example-instance" {
  vpc_id = aws_vpc.use-this-vpc-for-example-instance.id

  tags = {
    Name = "igw-example-instance"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.use-this-vpc-for-example-instance.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw-example-instance.id
#   }

  tags = {
    Name = "public-route-table"
  }
}

# resource "aws_route" "add-routes-public-route-table" {
#   route_table_id            = aws_route_table.public-route-table.id
#   destination_cidr_block    = "0.0.0.0/0"
#   gateway_id = aws_internet_gateway.igw-example-instance.id
# }

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.use-this-vpc-subnet-for-example-instance.id
  route_table_id = aws_route_table.public-route-table.id
}

# resource "aws_route_table_association" "igw-association" {
#   gateway_id     = aws_internet_gateway.igw-example-instance.id
#   route_table_id = aws_route_table.public-route-table.id
# }



resource "aws_security_group" "allow-all-traffic" {
  name        = "allow-all-traffic"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.use-this-vpc-for-example-instance.id

  tags = {
    Name = "allow-all-traffic"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow-all-traffic.id
  cidr_ipv4         = "0.0.0.0./0"
  ip_protocol       = "-1"
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow-all-traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}