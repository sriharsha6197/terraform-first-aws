resource "aws_vpc" "vpcEC2Terraform" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "vpcEC2Terraform"
  }
}

resource "aws_subnet" "vpcEC2TerraformSubnet" {
  vpc_id     = aws_vpc.vpcEC2Terraform.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "vpcEC2TerraformSubnet"
  }
}

resource "aws_internet_gateway" "IGWTerraform" {
  vpc_id = aws_vpc.vpcEC2Terraform.id

  tags = {
    Name = "IGWTerraform"
  }
}

# resource "aws_egress_only_internet_gateway" "IGWTerraform" {
#   vpc_id = aws_vpc.vpcEC2Terraform.id

#   tags = {
#     Name = "IGWTerraform"
#   }
# }

resource "aws_route_table" "PublicRouteTableTerraform" {
  vpc_id = aws_vpc.vpcEC2Terraform.id

  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.IGWTerraform.id
  # }

  tags = {
    Name = "PublicRouteTableTerraform"
  }
}

resource "aws_route_table_association" "b" {
  subnet_id = aws_subnet.vpcEC2TerraformSubnet.id
  route_table_id = aws_route_table.PublicRouteTableTerraform.id
}

# resource "aws_route" "addingRoutes" {
#   route_table_id            = aws_route_table.PublicRouteTableTerraform.id
#   destination_cidr_block    = "0.0.0.0/0"
#   gateway_id = aws_egress_only_internet_gateway.IGWTerraform.id
# }

resource "aws_security_group" "allow_all_traffic_terraform" {
  name        = "allow_all_traffic_terraform"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpcEC2Terraform.id

  tags = {
    Name = "allow_all_traffic_terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_all_traffic_terraform.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_all_traffic_terraform.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
