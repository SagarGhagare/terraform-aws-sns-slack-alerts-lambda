# Subscription to the SNS topic
resource "aws_sns_topic_subscription" "module_subscription" {
    topic_arn = "${aws_sns_topic.module_sns_topic.arn}"
    protocol  = "lambda"
    endpoint  = "${aws_lambda_function.module_function.arn}"
}

# Permission for SNS topic to invoke lambda function
resource "aws_lambda_permission" "with_sns" {
    statement_id  = "AllowExecutionFromSNS"
    action        = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.module_function.function_name}"
    principal     = "sns.amazonaws.com"
    source_arn    = "${aws_sns_topic.module_sns_topic.arn}"
}

# SNS Topic for errors
resource "aws_sns_topic" "module_sns_topic" {
  name  = "${var.environment}-publish-to-slack"
}

# Role and Policy for the Lambda
resource "aws_iam_role" "sns_to_slack_role" {
  name = "${var.environment}-lambda-sns-to-slack-role"

  assume_role_policy = "${file("${path.module}/sns-to-slack-role.json")}"
}

resource "aws_iam_role_policy" "sns_to_slack_role_policy" {
  name = "${var.environment}-lambda-sns-to-slack-role-policy"
  role = "${aws_iam_role.sns_to_slack_role.id}"

  policy = "${file("${path.module}/sns-to-slack-role-policy.json")}"
}

# Lambda
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/sns_post_to_slack_handler.py"
  output_path = "${path.module}/sns_post_to_slack_handler/lambda.zip"
}

resource "aws_lambda_function" "module_function" {
    filename         = "${data.archive_file.lambda.output_path}"
    function_name    = "${var.environment}-sns-post-to-slack"
    role             = "${aws_iam_role.sns_to_slack_role.arn}"
    handler          = "sns_post_to_slack_handler.lambda_handler"
    runtime          = "python3.6"
    timeout          = 30
    source_code_hash = "${base64sha256(file(data.archive_file.lambda.output_path))}"

    environment {
        variables = {
            WEBHOOK_URL = "${var.slack_webhook_url}"
            ICON_EMOJI  = "${var.icon_emoji}"
        }
    }
}

