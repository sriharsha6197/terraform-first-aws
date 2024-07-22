######################################IAM_ROLE_CREATION#####################################

resource "aws_iam_role" "ec2_role_for_instance" {
  name = "ec2_role_for_instance"
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
  name   = "iam_role_policyy"
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
  name = "iam_role_for_instance_latest"
  role = aws_iam_role.ec2_role_for_instance.name
}

output "instance_role_profile" {
  value = resource.aws_iam_instance_profile.iam_role_for_instance.name
}

