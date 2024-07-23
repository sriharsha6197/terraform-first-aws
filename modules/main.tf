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
  for_each = length(var.buckets)
  source = "./s3-bucket"
  buckets_to_create = var.buckets[for_each.index]
}
variable "buckets" {
  default = ["sri6197-bucket","harsha7916-bucket"]
}
terraform {
  backend "s3" {
    bucket = "my-tf-test-bucket-harsha"
    key = "state-file/"
    region = "us-east-1"
  } 
}
