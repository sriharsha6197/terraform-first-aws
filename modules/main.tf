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
  source = "./expense-app-create"
  for_each = var.instances
  component = each.key
  instance_profile = module.role.instance_role_profile
}

variable "instances" {
  type = set(string)
  default = [ "frontend","backend","mysql" ]
}
variable "env" {
  
}
terraform {
  backend "s3" {

  }
}