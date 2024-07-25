module "role" {
  source = "./iam_role"
}
module "bucket" {
  source = "./s3-bucket"
}
module "expense" {
  env = var.env
  instanceType = var.instanceType[index]
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