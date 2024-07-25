module "role" {
  env = var.env
  source = "./iam_role"
}
module "bucket" {
  env = var.env
  source = "./s3-bucket"
}
module "expense" {
  env = var.env
  instanceType = var.instanceType
  source = "./expense-app-create"
  for_each = var.instances
  component = each.key
  instance_profile = module.role.instance_role_profile
}

variable "instances" {
  type = set(string)
  default = [ "frontend","mysql","backend" ]
}
variable "env" {
  
}
variable "instanceType" {
  
}
terraform {
  backend "s3" {

  }
}