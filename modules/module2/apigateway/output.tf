output "api_url" {
  value       = aws_api_gateway_deployment.http_api_deployment.invoke_url
  sensitive   = false
  description = "description"
  depends_on  = []
}


output "api_arn" {
  value       = aws_api_gateway_deployment.http_api_deployment.execution_arn
  sensitive   = false
  description = "description"
  depends_on  = []
}
