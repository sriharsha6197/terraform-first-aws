env = "dev-ec2"
variable instanceType {
    type = list(string)
    default = ["t2.micro","t3.small","t3.medium"]
}