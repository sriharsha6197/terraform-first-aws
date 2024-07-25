######################################IAM_ROLE_CREATION#####################################

resource "aws_iam_role" "ec2_role_for_instance" {
  name = "${var.env}_ec2_role_for_instance1"
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
output "role_arn" {
  value = aws_iam_role.ec2_role_for_instance.arn
}
resource "aws_iam_role_policy" "iam_role_policyy" {
  name   = "${var.env}_iam_role_policyy1"
  role   = aws_iam_role.ec2_role_for_instance.id
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
resource "aws_iam_instance_profile" "iam_role_for_instance_latest" {
  name = "${var.env}_iam_role_for_instance_latest1"
  role = aws_iam_role.ec2_role_for_instance.name
}

output "instance_role_profile" {
  value = resource.aws_iam_instance_profile.iam_role_for_instance_latest.name
}

