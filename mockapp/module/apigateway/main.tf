########################################################################
# API Gateway
########################################################################
#API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = "${var.tag}-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

########################################################################
# hello lambda POST
########################################################################
#リソース(エンドポイント)
resource "aws_api_gateway_resource" "api" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
  path_part   = "test"
}

#メソッド
resource "aws_api_gateway_method" "api_post" {
  authorization = "NONE"
  #API Gatewayのエンドポイントに対して許可するHTTPメソッド
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.api.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}

#Proxy統合
resource "aws_api_gateway_integration" "api_post" {
  http_method = aws_api_gateway_method.api_post.http_method
  resource_id = aws_api_gateway_resource.api.id
  rest_api_id = aws_api_gateway_rest_api.api.id

  #API Gatewayからバックエンドに対してのHTTPメソッド(Lambdaの場合はPOST)
  integration_http_method = "POST"
  type        = "AWS_PROXY"
  uri = var.hello_lambda_arn
}

#公開(deploy)設定
resource "aws_api_gateway_deployment" "api_post" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api.id,
      aws_api_gateway_method.api_post.id,
      aws_api_gateway_integration.api_post.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

#ステージの設定
resource "aws_api_gateway_stage" "api_post" {
  deployment_id = aws_api_gateway_deployment.api_post.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "dev"
}

########################################################################
# hello lambda GET
########################################################################