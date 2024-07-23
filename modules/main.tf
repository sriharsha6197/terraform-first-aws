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
module "bucket" {
  source = "./s3-bucket"
}
terraform {
  backend "s3" {
    bucket = "sri6197-bucket"
    key = "state-file/terraform.tfstate"
    region = "us-east-1"
  }
}