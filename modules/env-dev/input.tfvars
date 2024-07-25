env = "dev-ec2"
instances = [ "frontend","mysql","backend" ]
instanceTypes = {
  default = {
    "frontend" = "t2.micro",
    "mysql" = "t3.micro",
    "backend" = "t3.medium"
}
}
