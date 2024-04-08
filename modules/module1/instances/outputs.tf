output "instance_urls" {
  value       = { for instance in aws_instance.endpoint : instance.tags.Name => instance.private_dns }
  sensitive   = false
  description = "DNS urls for all instances created"
  depends_on  = []
}