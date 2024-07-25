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
  instanceTypes = var.instanceTypes
  source = "./expense-app-create"
  for_each = var.instances
  component = each.key
  instance_profile = module.role.instance_role_profile
}

variable "instances" {
}
variable "env" {
  
}
variable "instanceTypes" {
  type = map(string)
  default = {

  }
}
terraform {
  backend "s3" {

  }
}