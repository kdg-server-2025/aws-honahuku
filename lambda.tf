# CI/CD側でlambdaのソースコードを格納するための箱
resource "aws_s3_bucket" "lambda_artifacts" {
  bucket = "kdg-aws-2025-honahuku-lambda-artifacts"
  tags = {
    Name = "kdg-aws-2025-honahuku-lambda-artifacts"
  }
}

# ロールを生成
resource "aws_iam_role" "lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# 生成した空のLambdaのファイルをS3にアップロード
resource "aws_s3_object" "lambda_file" {
  bucket = aws_s3_bucket.lambda_artifacts.id
  key    = "initial.zip"
  source = "${path.module}/.temp_files/lambda.zip"
}

# Lambda関数を生成
# ソースコードは空のLambdaのファイルのS3を参照
resource "aws_lambda_function" "first_function" {
  function_name = "first-function"
  role          = aws_iam_role.lambda.arn
  handler       = "main.handler"
  runtime       = "provided.al2023"
  timeout       = 120
  publish       = true
  s3_bucket     = aws_s3_bucket.lambda_artifacts.id
  s3_key        = aws_s3_object.lambda_file.id
}
