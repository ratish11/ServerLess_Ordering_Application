

resource "aws_api_gateway_rest_api" "http_api" {
    name = var.api_name
    description = "API for processing orders."   
}

resource "aws_api_gateway_resource" "service-a" {
    parent_id = aws_api_gateway_rest_api.http_api.root_resource_id
    rest_api_id = aws_api_gateway_rest_api.http_api.id
    path_part = "service-a"
}

resource "aws_api_gateway_method" "service-a" {
    authorization = "NONE"
    http_method   = "ANY"
    resource_id   = aws_api_gateway_resource.service-a.id
    rest_api_id   = aws_api_gateway_rest_api.http_api.id
}

resource "aws_api_gateway_integration" "service-a" {
    http_method = aws_api_gateway_method.service-a.http_method 
    resource_id = aws_api_gateway_resource.service-a.id
    rest_api_id = aws_api_gateway_rest_api.http_api.id
    type        = "HTTP_PROXY"
    integration_http_method = "ANY"
    uri = "http://${var.public_urls["Endpoint-A"]}/"
}

resource "aws_api_gateway_resource" "service-b" {
    parent_id = aws_api_gateway_rest_api.http_api.root_resource_id
    rest_api_id = aws_api_gateway_rest_api.http_api.id
    path_part = "service-b"
}

resource "aws_api_gateway_method" "service-b" {
    authorization = "NONE"
    http_method   = "ANY"
    resource_id   = aws_api_gateway_resource.service-b.id
    rest_api_id   = aws_api_gateway_rest_api.http_api.id
}

resource "aws_api_gateway_integration" "service-b" {
    http_method = aws_api_gateway_method.service-a.http_method 
    resource_id = aws_api_gateway_resource.service-b.id
    rest_api_id = aws_api_gateway_rest_api.http_api.id
    type        = "HTTP_PROXY"
    integration_http_method = "ANY"
    uri = "http://${var.public_urls["Endpoint-B"]}/"
}