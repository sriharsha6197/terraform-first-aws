module "role" {
  source = "./iam_role"
}

module "expense" {
  for_each = var.instances
  source = "./expense-app-create"
  component = each.key
  instance_profile = module.role.instance_role_profile
}

variable "instances" {
  type = set(string)
  default = [ "frontend","backend","mysql" ]
}
module "bucket" {
  source = "./s3-bucket"
}

terraform {
  backend "s3" {   
  }
}