######################################IAM_ROLE_CREATION#####################################

resource "aws_iam_role" "ec2_role_for_instances" {
  name = "ec2_role_for_instances"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "iam_role_policy" {
  name   = "iam_role_policy"
  role   = aws_iam_role.ec2_role_for_instances.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*",
          "ssm:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "attach_instance" {
  name = "attach_instance"
  role = aws_iam_role.ec2_role_for_instances.name
}



# # ###############################FRONTEND_BACKEND_MYSQL_DNSRECORDSOF_FRONTEND_MYSQL_BACKEND##############
resource "aws_instance" "frontend_instance_terraform" {
  ami           = local.ami
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.attach_instance.name
  subnet_id = local.subnet_id
  vpc_security_group_ids = [local.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "frontend_instance_terraform"
  }
}
resource "aws_route53_record" "www" {
  allow_overwrite = true
  zone_id = local.zone_id
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
      "sudo dnf install python3.12-pip.noarch -y",
      "sudo pip3.12 install botocore boto3",
      "sudo ansible-pull -i localhost, -U https://github.com/sriharsha6197/expense-ansible-test.git -e ansible_user=centos -e ansible_password=DevOps321 expense.yaml -e role_name=frontend"
     ]
  }
}






resource "aws_instance" "mysql_terraform" {
  ami = local.ami
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.attach_instance.name
  subnet_id = local.subnet_id
  vpc_security_group_ids = [local.security_group_id]
  associate_public_ip_address = true
  
  tags = {
    Name = "mysql_instance_Terraform"
  }
}
resource "aws_route53_record" "mysql" {
  allow_overwrite = true
  zone_id = local.zone_id
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
      "sudo dnf install python3.12-pip.noarch -y",
      "sudo pip3.12 install botocore boto3",
      "sudo ansible-pull -i localhost, -U https://github.com/sriharsha6197/expense-ansible-test.git -e ansible_user=centos -e ansible_password=DevOps321 expense.yaml -e role_name=mysql"
    ]
  }
}







resource "aws_instance" "backend_terraform" {
  ami = local.ami
  instance_type = "t3.medium"
  iam_instance_profile = aws_iam_instance_profile.attach_instance.name
  subnet_id = local.subnet_id
  vpc_security_group_ids = [local.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "backend_instance_terraform"
  }
}
resource "aws_route53_record" "backend" {
  allow_overwrite = true
  zone_id = local.zone_id
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
  depends_on = [ aws_route53_record.backend, aws_instance.mysql_terraform, aws_route53_record.mysql, null_resource.mysql_setup ]
  provisioner "remote-exec" {
    inline = [  
      "sudo dnf install ansible -y",
      "sudo dnf install python3.12-pip.noarch -y",
      "sudo pip3.12 install botocore boto3",
      "sudo ansible-pull -i localhost, -U https://github.com/sriharsha6197/expense-ansible-test.git -e ansible_user=centos -e ansible_password=DevOps321 expense.yaml -e role_name=backend"
    ]
  }
}