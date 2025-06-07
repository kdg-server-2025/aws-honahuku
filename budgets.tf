resource "aws_budgets_budget" "monthly_budget" {
  name         = "monthly-budget"
  budget_type  = "COST"
  limit_amount = "5"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 5
    threshold_type             = "ABSOLUTE_VALUE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["tech@honahuku.com"]
    subscriber_sns_topic_arns  = [aws_sns_topic.budget_alerts.arn]
  }
}

resource "aws_sns_topic" "budget_alerts" {
  name = "budget-alerts"
}

moved {
  from = aws_sns_topic_subscription.email_subscription
  to = aws_sns_topic_subscription.email_subscription_yamakawa
}

resource "aws_sns_topic_subscription" "email_subscription_yamakawa" {
  topic_arn = aws_sns_topic.budget_alerts.arn
  protocol  = "email"
  endpoint  = "tech@honahuku.com"
}
