module "frontend" {
  source = "./expense-app-create"
  component = "frontend"
}

module "backend" {
  source = "./expense-app-create"
  component = "backend"
}

module "mysql" {
  source = "./expense-app-create"
  component = "mysql"
}

