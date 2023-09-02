##########################################################################
# Lambda関数
##########################################################################
#zipファイルの作成
data "archive_file" "func_file" {
  type = "zip"
  source_file = "${var.module_path}/${var.function_file_name}.py"
  output_path = "${var.module_path}/${var.function_file_name}.zip"
}

#hello_world関数
resource "aws_lambda_function" "hello_world" {
  filename = "${var.module_path}/${var.function_file_name}.zip"
  function_name = "hello_world"
  role = var.hello_lambda_role
  #ファイル名.関数名
  handler = "hello.lambda_handler"
  runtime = "python3.10"
}

#Lambdaのリソースベースポリシー API Gateway => Lambda
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "Allow_APIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${var.api_arn}/*"
}