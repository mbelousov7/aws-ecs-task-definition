output "task_role_arn" {
  value       = aws_iam_role.task_iam_role.arn
  description = "created task iam role arn"
}

output "task_definition_arn" {
  value       = aws_ecs_task_definition.default.arn
  description = "created task definition arn"
}

output "aws_cloudwatch_log_group_arn" {
  value       = aws_cloudwatch_log_group.default.arn
  description = "created cloudwatch log group arn"
}