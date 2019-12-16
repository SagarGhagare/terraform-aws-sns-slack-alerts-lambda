# terraform-sns-to-slack-lambda
Terraform module which uses SNS topic and Lambda function to sends notifications to Slack

1. Provides a generic way of publishing messages to the Slack channel 
2. Outputs an SNS topic, messages should be published to that
3. The module's lambda will retrieve the message, and publish it to Slack 
4. The username will be the Subject of the message

# Dependencies and Prerequisites
Terraform version 0.12 and higher

AWS account

AWS CLI

# Usage
```
module "sns_to_slack_lambda" {
    source            = "sns_to_slack_lambda"
    slack_webhook_url = "https://hooks.slack.com/services/xxxxxx"
    environment       = "environment"
    icon_emoji        = ":emoji:"
}
```
