output "sqs_queue_url" {
  value = aws_sqs_queue.sqs-queue.id
  description = "The URL of the created SQS queue"
}
output "sqs_queue_arn" {
  value = aws_sqs_queue.sqs-queue.arn
  description = "The ARN of the created SQS queue"
}
