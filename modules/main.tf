module "frontend" {
  source = "./expense-app-create"
  component = "frontend"
}

module "mysql" {
  source = "./expense-app-create"
  component = "mysql"
}

module "backend" {
  source = "./expense-app-create"
  component = "backend"
}
