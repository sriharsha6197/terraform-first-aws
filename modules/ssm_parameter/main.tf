resource "aws_ssm_parameter" "expense_frontend_backend_ip12" {
  depends_on = [aws_instance.instance ]
  name  = "expense_frontend_backend_ip2"
  type  = "String"
  value = var.instance
}