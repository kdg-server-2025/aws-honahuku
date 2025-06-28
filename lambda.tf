# CI/CD側でlambdaのソースコードを格納するための箱
resource "aws_s3_bucket" "kdg_2025_lambda_yamakawa" {
  bucket = "kdg-2025-lambda-yamakawa"
  tags = {
    Name = "kdg-2025-lambda-yamakawa"
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

# 初回のみ利用する空のLambdaのファイルを生成
data "archive_file" "initial_lambda_package" {
  type        = "zip"
  output_path = "${path.module}/.temp_files/lambda.zip"
  source {
    content  = "# empty"
    filename = "main.py"
  }
}

# 生成した空のLambdaのファイルをS3にアップロード
resource "aws_s3_object" "lambda_file" {
  bucket = aws_s3_bucket.kdg_2025_lambda_yamakawa.id
  key    = "initial.zip"
  source = "${path.module}/.temp_files/lambda.zip"
}

# Lambda関数を生成
# ソースコードは空のLambdaのファイルのS3を参照
resource "aws_lambda_function" "lambda_test" {
  function_name = "lambda_test"
  role          = aws_iam_role.lambda.arn
  handler       = "main.handler"
  runtime       = "provided.al2023"
  timeout       = 120
  publish       = true
  s3_bucket     = aws_s3_bucket.kdg_2025_lambda_yamakawa.id
  s3_key        = aws_s3_object.lambda_file.id
}
