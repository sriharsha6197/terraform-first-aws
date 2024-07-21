module "expense" {
  count = length(var.instances)
  source = "./expense-app-create"
  for_each = [aws_vpc.vpcEC2Terraform, aws_subnet.vpcEC2TerraformSubnet, aws_internet_gateway.IGWTerraform, aws_route_table.PublicRouteTableTerraform, aws_security_group.allow_all_traffic_terraform]
  component = var.instances[count.index]
}

variable "instances" {
  default = [ "frontend","mysql","backend" ]
}