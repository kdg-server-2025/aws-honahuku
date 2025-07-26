# CI/CD側でlambdaのソースコードを格納するための箱
resource "aws_s3_bucket" "lambda_artifacts" {
  # AWS S3 で一意である(重複がない)必要がある
  # 例) kdg-aws-2025-ここに自分のgithubのユーザー名-lambda-artifacts
  bucket = "kdg-aws-2025-honahuku-lambda-artifacts"
  tags = {
    # bucket に指定した内容と同じものを書く
    Name = "kdg-aws-2025-honahuku-lambda-artifacts"
  }
}

# lambda 実行時に必要な権限をまとめる role を定義する
resource "aws_iam_role" "lambda" {
  name = "iam_for_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

# CloudWatch Logs への書き込み権限を 定義した role に対して付与する
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# GetAccountSettings も実行時に必要な権限なので付与する
resource "aws_iam_role_policy" "get_account_settings" {
  name = "GetAccountSettingsPermission"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "lambda:GetAccountSettings"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# 初回のみ利用する空のLambdaのファイルを生成
data "archive_file" "initial_lambda_package" {
  type        = "zip"
  output_path = "${path.module}/.temp_files/lambda.zip"
  source {
    content  = "# empty"
    filename = "hoge.txt"
  }
}

# (初回のみ)空のLambdaのファイルをS3にアップロード
resource "aws_s3_object" "lambda_file" {
  bucket = aws_s3_bucket.lambda_artifacts.id
  key    = "initial.zip"
  source = "${path.module}/.temp_files/lambda.zip"
}

# Lambda関数を生成
resource "aws_lambda_function" "kdg_lamda_sample" {
  function_name = "kdg-lamda-sample"
  role          = aws_iam_role.lambda.arn
  handler       = "main.handler"
  runtime       = "provided.al2023"
  timeout       = 120
  publish       = true
  s3_bucket     = aws_s3_bucket.lambda_artifacts.id
  s3_key        = aws_s3_object.lambda_file.key
}

# 外部からリクエストを飛ばすためのエンドポイント
resource "aws_lambda_function_url" "kdg_lamda_sample" {
  function_name      = aws_lambda_function.kdg_lamda_sample.function_name
  authorization_type = "NONE"
}

# Lambda関数のURLをアウトプットする
output "lambda_kdg_lamda_sample_url" {
  description = "デプロイした first_function の URL"
  value       = aws_lambda_function_url.kdg_lamda_sample.function_url
}
