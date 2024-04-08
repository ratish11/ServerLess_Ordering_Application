resource "aws_api_gateway_rest_api" "http_api" {
    name = var.api_name
    # description = "API for processing orders."   
}

resource "aws_api_gateway_resource" "service" {
    parent_id = aws_api_gateway_rest_api.http_api.root_resource_id
    rest_api_id = aws_api_gateway_rest_api.http_api.id
    path_part = "items"
}

resource "aws_api_gateway_resource" "serviceId" {
    parent_id = aws_api_gateway_resource.service.id
    rest_api_id = aws_api_gateway_rest_api.http_api.id
    path_part = "{id}"
}
resource "aws_api_gateway_method" "service" {
    authorization = "NONE"
    http_method   = "GET"
    resource_id   = aws_api_gateway_resource.serviceId.id
    rest_api_id   = aws_api_gateway_rest_api.http_api.id
}

resource "aws_api_gateway_integration" "service" {
    http_method = aws_api_gateway_method.service.http_method 
    resource_id = aws_api_gateway_resource.serviceId.id
    rest_api_id = aws_api_gateway_rest_api.http_api.id
    type        = "AWS_PROXY"
    integration_http_method = "GET"
    uri = var.lambda_invoke_arn
}

resource "aws_api_gateway_deployment" "http_api_deployment" {
    rest_api_id = aws_api_gateway_rest_api.http_api.id
    stage_name  = ""
    lifecycle {
        create_before_destroy = true
    }
    depends_on = [aws_api_gateway_integration.service]
}