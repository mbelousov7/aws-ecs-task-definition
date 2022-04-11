locals {

  task_name = var.task_name == "default" ? (
    "${var.labels.prefix}-${var.labels.stack}-${var.labels.component}-task-${var.labels.env}"
  ) : var.task_name

  cloudwatch_log_group_name = var.cloudwatch_log_group_name == "default" ? (
    "${var.labels.prefix}-${var.labels.stack}-${var.labels.component}-log-group-${var.labels.env}"
  ) : var.cloudwatch_log_group_name

  log_configuration = var.log_configuration ? {
    logDriver = "awslogs",
    options = {
      awslogs-group         = aws_cloudwatch_log_group.default.name
      awslogs-region        = var.aws_region,
      awslogs-stream-prefix = "ecs"
  } } : null

  container_definition = {
    name                   = var.container_name
    image                  = var.container_image
    essential              = var.essential
    cpu                    = var.container_cpu
    memory                 = var.container_memory
    logConfiguration       = local.log_configuration
    environment            = var.environment
    entryPoint             = var.entrypoint
    command                = var.command
    workingDirectory       = var.working_directory
    readonlyRootFilesystem = var.readonly_root_filesystem
    mountPoints            = var.mount_points
  }

  container_definition_without_null = {
    for k, v in local.container_definition :
    k => v
    if v != null
  }

  container_definition_json_map = jsonencode(merge(local.container_definition_without_null, var.container_definition))

}

resource "aws_cloudwatch_log_group" "default" {
  name              = "/fargate/${local.cloudwatch_log_group_name}"
  retention_in_days = 30
  tags = merge(
    var.labels,
    var.tags,
    { Name = local.cloudwatch_log_group_name }
  )
}

resource "aws_ecs_task_definition" "default" {
  family                   = local.task_name
  requires_compatibilities = [var.launch_type]
  network_mode             = var.task_network_mode
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.task_iam_role.arn
  task_role_arn            = aws_iam_role.task_iam_role.arn
  container_definitions    = "[${local.container_definition_json_map}]"
  tags = merge(
    var.labels,
    var.tags,
    { Name = local.task_name }
  )

}


