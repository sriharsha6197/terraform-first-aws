
# ###############################FRONTEND_BACKEND_MYSQL_DNSRECORDSOF_FRONTEND_MYSQL_BACKEND##############
resource "aws_instance" "instance" {
  ami           = local.ami
  instance_type = "t2.micro"
  iam_instance_profile = "iam_role_for_instance"
  subnet_id = local.subnet_id
  vpc_security_group_ids = [local.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.component}_instance_terraform"
  }
}
resource "aws_route53_record" "record" {
  allow_overwrite = true
  zone_id = local.zone_id
  name    = "${var.component}.${var.hosted_zone}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.instance.private_ip]
}
# resource "aws_ssm_parameter" "expense_frontend_backend_ip" {
#   depends_on = [ aws_instance.backend_terraform ]
#   name  = "expense_frontend_backend_ip"
#   type  = "String"
#   value = aws_instance.backend_terraform.private_ip
# }
resource "null_resource" "frontend_setup" {
  connection {
    type = "ssh"
    user = "centos"
    password = "DevOps321"
    host = aws_instance.instance.public_ip
  }
  depends_on = [ aws_route53_record.record ]
  provisioner "remote-exec" {
    inline = [ 
      "sudo dnf install ansible -y",
      "sudo dnf install python3.12-pip.noarch -y",
      "sudo pip3.12 install botocore boto3",
      "sudo ansible-pull -i localhost, -U https://github.com/sriharsha6197/expense-ansible-test.git -e ansible_user=centos -e ansible_password=DevOps321 expense.yaml -e role_name=${var.component}"
     ]
  }
}