###############################################VPC_SUBNET_IGW_ROUTETABLE_ROUTES_SECURITYGROUP#########################
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
resource "aws_route" "addingRoutes" {
  route_table_id            = aws_route_table.PublicRouteTableTerraform.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.IGWTerraform.id
}
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


#########################################################FRONTEND_BACKEND_MYSQL_DNSRECORDSOF_FRONTEND_MYSQL_BACKEND###############
resource "aws_instance" "frontend_instance_terraform" {
  ami           = "ami-0b4f379183e5706b9"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.vpcEC2TerraformSubnet.id
  vpc_security_group_ids = [aws_security_group.allow_all_traffic_terraform.id]
  associate_public_ip_address = true

  tags = {
    Name = "frontendTerraform"
  }
}
resource "aws_route53_record" "www" {
  allow_overwrite = true
  zone_id = "Z06906613UXR2QKNVHT2M"
  name    = "frontend.sriharsha.shop"
  type    = "A"
  ttl     = 300
  records = [aws_instance.frontend_instance_terraform.private_ip]
}

resource "aws_instance" "mysql_terraform" {
  ami = "ami-0b4f379183e5706b9"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.vpcEC2TerraformSubnet.id
  vpc_security_group_ids = [aws_security_group.allow_all_traffic_terraform.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "mysqlTerraform"
  }
}
resource "aws_route53_record" "mysql" {
  allow_overwrite = true
  zone_id = "Z06906613UXR2QKNVHT2M"
  name    = "mysql.sriharsha.shop"
  type    = "A"
  ttl     = 300
  records = [aws_instance.mysql_terraform.private_ip]
}

resource "aws_instance" "backend_terraform" {
  ami = "ami-0b4f379183e5706b9"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.vpcEC2TerraformSubnet.id
  vpc_security_group_ids = [aws_security_group.allow_all_traffic_terraform.id]
  associate_public_ip_address = true

  tags = {
    Name = "backend_terraform"
  }
}
resource "aws_route53_record" "backend" {
  allow_overwrite = true
  zone_id = "Z06906613UXR2QKNVHT2M"
  name = "backend.sriharsha.shop"
  type = "A"
  ttl = 300
  records = [aws_instance.backend_terraform.private_ip]
}