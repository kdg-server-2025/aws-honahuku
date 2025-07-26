# 1分間のエラー数が2回以上になったらアラームを発報する
resource "aws_cloudwatch_metric_alarm" "lambda_error" {
  alarm_name          = "${aws_lambda_function.kdg_lamda_sample.function_name}-high-error-count-alarm"
  alarm_description   = "${aws_lambda_function.kdg_lamda_sample.function_name} でエラー発生回数が増えています"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60 # 1分間
  statistic           = "Sum"
  # しきい値
  threshold = 2

  dimensions = {
    FunctionName = aws_lambda_function.kdg_lamda_sample.function_name
  }

  alarm_actions = [aws_sns_topic.lambda_alarm_topic.arn]
  ok_actions    = [aws_sns_topic.lambda_alarm_topic.arn]

  tags = {
    Name = "${aws_lambda_function.kdg_lamda_sample.function_name}-high-error-count-alarm"
  }
}

# アラーム通知用のSNSトピックとサブシクリプション
resource "aws_sns_topic" "lambda_alarm_topic" {
  name = "${aws_lambda_function.kdg_lamda_sample.function_name}-alarm-topic"
}
resource "aws_sns_topic_subscription" "lambda_alarm" {
  topic_arn = aws_sns_topic.lambda_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.notification_email
}
