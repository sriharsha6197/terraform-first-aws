# ###############################FRONTEND_BACKEND_MYSQL_DNSRECORDSOF_FRONTEND_MYSQL_BACKEND##############


resource "aws_instance" "instance" {
  ami           = local.ami
  for_each = var.instanceTypes
  instance_type = each.value
  iam_instance_profile = var.instance_profile
  subnet_id = local.subnet_id
  vpc_security_group_ids = [local.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.env}_${var.component}_instance_terraform"
  }
}
output "instance" {
  value = aws_instance.instance.private_ip
}
resource "aws_route53_record" "record" {
  allow_overwrite = true
  zone_id = local.zone_id
  name    = "${var.env}.${var.component}.${var.hosted_zone}"
  type    = "A"
  ttl     = 300
  records = aws_instance.instance.private_ip
}

# resource "null_resource" "frontend_setup" {
#   connection {
#     type = "ssh"
#     user = "centos"
#     password = "DevOps321"
#     host = aws_instance.instance.public_ip
#   }
#   depends_on = [ aws_route53_record.record ]
#   provisioner "remote-exec" {
#     inline = [ 
#       "sudo dnf install ansible -y",
#       "sudo dnf install python3.12-pip.noarch -y",
#       "sudo pip3.12 install botocore boto3",
#       "sudo ansible-pull -i localhost, -U https://github.com/sriharsha6197/expense-ansible-test.git -e ansible_user=centos -e ansible_password=DevOps321 expense.yaml -e role_name=${var.component}"
#      ]
#   }
# }