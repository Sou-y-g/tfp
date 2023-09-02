resource "aws_api_gateway_rest_api" "api" {
  name = "${var.tag}-apigateway"

  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "api"
      version = "1.0"
    }
    paths = {
      "/path1" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "POST"
            payloadFormatVersion = "1.0"
            type                 = "AWS_PROXY"
            uri                  = var.hello_lambda_arn
          }
        }
      }
    }
  })

#あとで"EDGE"に変更
#CloudFrontにて公開
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

#API Gatwayを公開するための設定
resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id

#(上で作成した)apigatewayの定義(body = ...)を変更した場合、自動でデプロイする
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_api_gateway_rest_api.api]
}

#dev-stageの設定
resource "aws_api_gateway_stage" "dev_stage" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "dev"
}