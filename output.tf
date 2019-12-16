output "topic_arn" {
  value = "${aws_sns_topic.module_sns_topic.arn}"
}
