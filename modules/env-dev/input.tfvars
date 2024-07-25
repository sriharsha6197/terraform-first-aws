env = "dev-ec2"
instances = [ "frontend","mysql","backend" ]
variable "instanceTypes"{
  type = map(string)
  default = {
    "frontend" = "t2.micro",
    "mysql" = "t3.micro",
    "backend" = "t3.medium"
  }
}