######################################IAM_ROLE_CREATION#####################################

resource "aws_iam_role" "ec2_role_for_instances1" {
  name = "ec2_role_for_instances1"
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

resource "aws_iam_role_policy" "iam_role_policy1" {
  name   = "iam_role_policy1"
  role   = aws_iam_role.ec2_role_for_instances1.id

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

resource "aws_iam_instance_profile" "attach_instance1" {
  name = "attach_instance1"
  role = aws_iam_role.ec2_role_for_instances1.name
}


#############################################KEEPING_THE_CODE_SRY_FOR_MODULES############################


resource "aws_instance" "instance" {
  ami           = local.ami
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.attach_instance.name
  subnet_id = local.subnet_id
  vpc_security_group_ids = [local.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.component}_terraform"
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
output "ip" {
  value = aws_instance.instance.private_ip
}
# resource "aws_ssm_parameter" "ssm" {
#   depends_on = [ module.backend ]
#   name  = "expense_${var.component}_module.backend.ip"
#   type  = "String"
#   value = module.backend.aws_instance.instance.private_ip
# }
# resource "null_resource" "ansible" {
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