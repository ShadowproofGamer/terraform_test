#provider "aws" {
#  region = "us-east-1"
#}
#
## Create a regional API Gateway
#resource "aws_api_gateway_rest_api" "api_gw" {
#  name        = "backend-api"
#  description = "Backend API Gateway"
#}
#
## Create a resource
#resource "aws_api_gateway_resource" "api_gw_res" {
#  rest_api_id = aws_api_gateway_rest_api.api_gw.id
#  parent_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
#  path_part   = "example"
#}
#
## Create a method
#resource "aws_api_gateway_method" "api_gw_method" {
#  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
#  resource_id   = aws_api_gateway_resource.api_gw_res.id
#  http_method   = "GET"
#  authorization = "NONE"
#}
#
## Create an integration
#resource "aws_api_gateway_integration" "api_gw_ci" {
#  rest_api_id             = aws_api_gateway_rest_api.api_gw.id
#  resource_id             = aws_api_gateway_resource.api_gw_res.id
#  http_method             = aws_api_gateway_method.api_gw_method.http_method
#  integration_http_method = "GET"
#  type                    = "HTTP_PROXY"
#  uri                     = "http://example.com"
#}
#
## Create a deployment
#resource "aws_api_gateway_deployment" "api_gw_cd" {
#  depends_on    = [aws_api_gateway_integration.api_gw_ci]
#  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
#  stage_name    = "test"
#}
#
## Create a custom domain name
#resource "aws_api_gateway_domain_name" "api_gw_dn" {
#  domain_name              = "api.tictactoe-backend.com"
#  regional_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#}
#
## Create a base path mapping
#resource "aws_api_gateway_base_path_mapping" "api_gw_map" {
#  domain_name = aws_api_gateway_domain_name.api_gw_dn.domain_name
#  rest_api_id = aws_api_gateway_rest_api.api_gw.id
#  stage_name  = aws_api_gateway_deployment.api_gw_cd.stage_name
#}
#
## Create a regional custom domain name
#resource "aws_api_gateway_base_path_mapping" "api_gw_map_regional" {
#  domain_name = aws_api_gateway_domain_name.example_regional.domain_name
#  rest_api_id = aws_api_gateway_rest_api.api_gw.id
#  stage_name  = aws_api_gateway_deployment.example_regional.stage_name
#}
#
## Create a mapping
#resource "aws_route53_record" "example" {
#  zone_id = "XXXXXXXXXXXXXX"
#  name    = aws_api_gateway_domain_name.example_regional.domain_name
#  type    = "A"
#  alias {
#    name                   = aws_api_gateway_base_path_mapping.api_gw_map_regional.cloudfront_domain_name
#    zone_id                = aws_api_gateway_base_path_mapping.api_gw_map_regional.cloudfront_zone_id
#    evaluate_target_health = false
#  }
#}
