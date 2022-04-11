variable "region" {
  type = string
}

variable "labels" {
}

variable "cloudteam_policy_arns" {
  default = []
}

variable "fargate_task_scheduled" {
  default = {
  component                   = "componentName"
  container_name              = "nginx"
  container_image             = "nginx:1.14.2"
  task_cpu                    = 256
  task_memory                 = 512
  }
}

variable "task_role_policy_statements" {
  default = {}
}