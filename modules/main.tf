# module "expense" {
#   count = length(var.instances)
#   source = "./expense-app-create"
#   component = var.instances[count.index]
# }

# variable "instances" {
#   default = [ "frontend","mysql","backend" ]
# }