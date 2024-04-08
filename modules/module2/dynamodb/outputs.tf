output "db_arn" {
    value       = aws_dynamodb_table.http_get_items.arn
    sensitive   = false
    description = "DynamoDB ARN to be shared"
    depends_on  = []
}