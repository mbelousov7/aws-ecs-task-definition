module "fargatetd_ecs_task_definition" {
  source                      = "../../"
  aws_region                  = var.region
  container_name              = var.fargate_task_scheduled.container_name
  container_image             = var.fargate_task_scheduled.container_image
  task_cpu                    = var.fargate_task_scheduled.task_cpu
  task_memory                 = var.fargate_task_scheduled.task_memory
  task_role_policy_arns       = var.cloudteam_policy_arns
  task_role_policy_statements = var.task_role_policy_statements
  labels = merge(
    { component = "componentName" },
    var.labels
  )
}