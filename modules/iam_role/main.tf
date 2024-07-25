######################################IAM_ROLE_CREATION#####################################

resource "aws_iam_role" "ec2_role_for_instance1" {
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
  value = aws_iam_role.ec2_role_for_instance1.arn
}
resource "aws_iam_role_policy" "iam_role_policyy1" {
  name   = "${var.env}_iam_role_policyy1"
  role   = aws_iam_role.ec2_role_for_instance1.id
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
resource "aws_iam_instance_profile" "iam_role_for_instance_latest1" {
  name = "${var.env}_iam_role_for_instance_latest1"
  role = aws_iam_role.ec2_role_for_instance1.name
}

output "instance_role_profile1" {
  value = resource.aws_iam_instance_profile.iam_role_for_instance_latest1.name
}

