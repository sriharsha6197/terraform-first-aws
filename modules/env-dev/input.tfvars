env = "dev-ec2"
instances = [ "frontend","mysql","backend" ]
instanceTypes = {
    frontend = "t2.micro",
    mysql = "t3.micro",
    backend = "t3.medium"
}
Name = instance-var.env
