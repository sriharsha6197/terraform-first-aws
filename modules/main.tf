# module "role" {
#   source = "./iam_role"
# }

# module "frontend" {
#   count = length(var.instances)
#   source = "./expense-app-create"
#   component = var.instances[count.index]
#   instance_profile = module.role.instance_role_profile
# }

# variable "instances" {
#   default = [ "frontend","backend","mysql" ]
# }

module "s3" {
  source = "./s3-bucket"
}

terraform {
  backend "local" {
  }
}