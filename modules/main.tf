module "frontend" {
  source = "./expense-app-create"
  componentharsha = "frontend"
}

module "backend" {
  source = "./expense-app-create"
  componentharsha = "backend"
}