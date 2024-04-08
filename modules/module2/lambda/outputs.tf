output "lambda_invoke_arn" {
  value       = aws_lambda_function.lambda_func.invoke_arn
  sensitive   = false
  description = "description"
  depends_on  = []
}
