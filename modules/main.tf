module "role" {
  source = "./iam_role"
}
module "bucket" {
  source = "./s3-bucket"
}
module "expense" {
  source = "./expense-app-create"
  for_each = var.instances
  component = each.key
  instance_profile = module.role.instance_role_profile
}

variable "instances" {
  type = set(string)
  default = [ "frontend","backend","mysql" ]
}


terraform {
  backend "s3" {   
  }
}