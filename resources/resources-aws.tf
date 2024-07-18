# ###############################FRONTEND_BACKEND_MYSQL_DNSRECORDSOF_FRONTEND_MYSQL_BACKEND##############
resource "aws_instance" "frontend_instance_terraform" {
  ami           = data.aws_ami.centos_ami.image_id
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.datablock_subnet.id
  vpc_security_group_ids = [data.aws_security_group.datablock_security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "frontend_instance_terraform"
  }
}
resource "aws_route53_record" "www" {
  allow_overwrite = true
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "frontend.${var.hosted_zone}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.frontend_instance_terraform.private_ip]
}
resource "aws_ssm_parameter" "expense_frontend_backend_ip" {
  depends_on = [ aws_instance.backend_terraform ]
  name  = "expense_frontend_backend_ip"
  type  = "String"
  value = aws_instance.backend_terraform.private_ip
}
resource "null_resource" "frontend_setup" {
  connection {
    type = "ssh"
    user = "centos"
    password = "DevOps321"
    host = aws_instance.frontend_instance_terraform.public_ip
  }
  depends_on = [ aws_route53_record.www ]
  provisioner "remote-exec" {
    inline = [ 
      "sudo dnf install ansible -y",
      "dnf install python3.12-pip.noarch -y",
      "pip3.12 install botocore boto3",
      "sudo ansible-pull -i localhost, -U https://github.com/sriharsha6197/expense-ansible-test.git -e ansible_user=centos -e ansible_password=DevOps321 expense.yaml -e role_name=frontend"
     ]
  }
}






resource "aws_instance" "mysql_terraform" {
  ami = data.aws_ami.centos_ami.image_id
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.datablock_subnet.id
  vpc_security_group_ids = [data.aws_security_group.datablock_security_group.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "mysql_instance_Terraform"
  }
}
resource "aws_route53_record" "mysql" {
  allow_overwrite = true
  zone_id = data.aws_route53_zone.hosted_zone.id
  name    = "mysql.${var.hosted_zone}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.mysql_terraform.private_ip]
}

resource "null_resource" "mysql_setup" {
  connection {
    type = "ssh"
    user = "centos"
    password = "DevOps321"
    host = aws_instance.mysql_terraform.public_ip
  }
  depends_on = [ aws_route53_record.mysql ]
  provisioner "remote-exec" {
    inline = [  
      "sudo dnf install ansible -y",
      "dnf install python3.12-pip.noarch -y",
      "pip3.12 install botocore boto3",
      "sudo ansible-pull -i localhost, -U https://github.com/sriharsha6197/expense-ansible-test.git -e ansible_user=centos -e ansible_password=DevOps321 expense.yaml -e role_name=mysql"
    ]
  }
}







resource "aws_instance" "backend_terraform" {
  ami = data.aws_ami.centos_ami.id
  instance_type = "t3.medium"
  subnet_id = data.aws_subnet.datablock_subnet.id
  vpc_security_group_ids = [data.aws_security_group.datablock_security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "backend_instance_terraform"
  }
}
resource "aws_route53_record" "backend" {
  allow_overwrite = true
  zone_id = data.aws_route53_zone.hosted_zone.id
  name = "backend.${var.hosted_zone}"
  type = "A"
  ttl = 300
  records = [aws_instance.backend_terraform.private_ip]
}
resource "aws_ssm_parameter" "expense_backend_mysql_ip" {
  depends_on = [ aws_instance.mysql_terraform ]
  name  = "expense_backend_mysql_ip"
  type  = "String"
  value = aws_instance.mysql_terraform.private_ip
}
resource "null_resource" "backend" {
  connection {
    type = "ssh"
    user = "centos"
    password = "DevOps321"
    host = aws_instance.backend_terraform.public_ip
  }
  provisioner "remote-exec" {
    inline = [  
      "sudo dnf install ansible -y",
      "dnf install python3.12-pip.noarch -y",
      "pip3.12 install botocore boto3",
      "sudo ansible-pull -i localhost, -U https://github.com/sriharsha6197/expense-ansible-test.git -e ansible_user=centos -e ansible_password=DevOps321 expense.yaml -e role_name=backend"
    ]
  }
}