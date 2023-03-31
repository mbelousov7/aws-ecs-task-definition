output "task_role_arn" {
  value       = aws_iam_role.task_iam_role.arn
  description = "created task iam role arn"
}

output "task_definition_arn" {
  value       = aws_ecs_task_definition.default.arn
  description = "created task definition arn"
}

output "task_definition_family" {
  value       = aws_ecs_task_definition.default.family
  description = "created task family name"
}

output "container_definition_name" {
  value       = local.container_definition.name
  description = "created container definition name"
}

output "aws_cloudwatch_log_group_arn" {
  value       = aws_cloudwatch_log_group.default.arn
  description = "created cloudwatch log group arn"
}

output "aws_cloudwatch_log_group_name" {
  value       = aws_cloudwatch_log_group.default.name
  description = "created cloudwatch log group name"
}