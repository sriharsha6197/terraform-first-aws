# ###############################FRONTEND_BACKEND_MYSQL_DNSRECORDSOF_FRONTEND_MYSQL_BACKEND##############
# resource "aws_instance" "frontend_instance_terraform" {
#   ami           = data.aws_ami.centos_ami.image_id
#   instance_type = "t2.micro"
#   subnet_id = data.aws_subnet.datablock_subnet.id
#   vpc_security_group_ids = [data.aws_security_group.datablock_security_group.id]
#   associate_public_ip_address = true

#   tags = {
#     Name = "frontendTerraform"
#   }
# }
# resource "aws_route53_record" "www" {
#   allow_overwrite = true
#   zone_id = data.aws_route53_zone.hosted_zone.zone_id
#   name    = "frontend.${var.hosted_zone}"
#   type    = "A"
#   ttl     = 300
#   records = [aws_instance.frontend_instance_terraform.private_ip]
# }

# resource "null_resource" "frontend_setup" {
#   provisioner "local-exec" {
#     command = <<EOF
#     pwd
#     dnf install ansible -y
#     EOF
#   }
# }

# resource "aws_instance" "mysql_terraform" {
#   ami = data.aws_ami.centos_ami.image_id
#   instance_type = "t2.micro"
#   subnet_id = data.aws_subnet.datablock_subnet.id
#   vpc_security_group_ids = [data.aws_security_group.datablock_security_group.id]
#   associate_public_ip_address = true
  
#   tags = {
#     Name = "mysqlTerraform"
#   }
# }
# resource "aws_route53_record" "mysql" {
#   allow_overwrite = true
#   zone_id = data.aws_route53_zone.hosted_zone.id
#   name    = "mysql.${var.hosted_zone}"
#   type    = "A"
#   ttl     = 300
#   records = [aws_instance.mysql_terraform.private_ip]
# }

# resource "aws_instance" "backend_terraform" {
#   ami = data.aws_ami.centos_ami.id
#   instance_type = "t2.micro"
#   subnet_id = data.aws_subnet.datablock_subnet.id
#   vpc_security_group_ids = [data.aws_security_group.datablock_security_group.id]
#   associate_public_ip_address = true

#   tags = {
#     Name = "backend_terraform"
#   }
# }
# resource "aws_route53_record" "backend" {
#   allow_overwrite = true
#   zone_id = data.aws_route53_zone.hosted_zone.id
#   name = "backend.sriharsha.shop"
#   type = "A"
#   ttl = 300
#   records = [aws_instance.backend_terraform.private_ip]
# }