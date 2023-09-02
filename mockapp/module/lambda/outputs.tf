output "hello_lambda_arn" {
  value = aws_lambda_function.hello_world.invoke_arn
}