##################################DATA-BLOCK-FOR-AWS_AMI#############
data "aws_ami" "centos_ami" {
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = [973714476881]
}

###################################VARIABLE_AND_DATA_BLOCK_FOR_SUBNETiD#########
variable "subnet_id" {
  default = "subnet-01ec80bf436ba7ca8"
}
data "aws_subnet" "datablock_subnet" {
  id = var.subnet_id
}

##################################SECURITYGROUP_VARIABLE_BLOCK_DATA_BLOCK#######
variable "security_group_id" {
  default = "sg-094dba37ab0ca3d62"
}
data "aws_security_group" "datablock_security_group" {
  id = var.security_group_id
}

#####################################ROUTE53_ZONE_ID###############
variable "hosted_zone" {
  default = "sriharsha.shop"
}
data "aws_route53_zone" "hosted_zone" {
  name = var.hosted_zone
}
