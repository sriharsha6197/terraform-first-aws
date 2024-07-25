env = "prod"
instances = ["frontend","mysql","backend"]
instanceTypes = {
    frontend = "t3.small",
    mysql = "t3.small",
    backend = "t3.medium"
}
Name = var.env-INSTANCE