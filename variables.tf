######################################## names, labels, tags ########################################
variable "labels" {
  type = object({
    prefix    = string
    stack     = string
    component = string
    env       = string
  })
  description = "Minimum required map of labels(tags) for creating aws resources"
}


variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}

variable "task_name" {
  type        = string
  description = <<-EOT
      optionally define a custom value for the task family and tag=Name parameter
      in aws_cloudwatch_event_rule. By default, it is defined as a construction from var.labels
    EOT
  default     = "default"
}

variable "task_iam_role_name" {
  type        = string
  description = <<-EOT
      optionally define a custom value for the task iam role name and tag=Name parameter
      in aws_iam_role. By default, it is defined as a construction from var.labels
    EOT
  default     = "default"
}

variable "cloudwatch_log_group_name" {
  type        = string
  description = <<-EOT
      optionally define a custom value for the name and tag=Name parameter
      in aws_cloudwatch_log_group. By default, it is defined as a construction from var.labels
    EOT
  default     = "default"
}




######################################## iam roles and policies vars ########################################
variable "task_role_policy_arns_default" {
  description = "default arns list for task"
  default = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

variable "task_role_policy_arns" {
  type        = list(string)
  description = "A list of IAM Policy ARNs to attach to the generated task role."
  default     = []
}

variable "task_role_policy_statements" {
  type        = map(any)
  description = <<-EOT
    A `map` of zero or multiple role policies statements 
    which will be attached to task role(in addition to default)
    EOT
  default     = {}
}

variable "permissions_boundary" {
  type        = string
  description = "A permissions boundary ARN to apply to the roles that are created."
  default     = ""
}

######################################## task definition vars ########################################


variable "aws_region" {
  type        = string
  description = "aws region for logs configuration"
}

variable "launch_type" {
  type        = string
  description = "The launch type on which to run your service. Valid values are `EC2` and `FARGATE`"
  default     = "FARGATE"
}

variable "task_network_mode" {
  type        = string
  description = "The network mode to use for the task. This is required to be `awsvpc` for `FARGATE` `launch_type` or `null` for `EC2` `launch_type`"
  default     = "awsvpc"
}

variable "task_cpu" {
  type        = number
  description = "The number of CPU units used by the task. If using `FARGATE` launch type `task_cpu` must match [supported memory values](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size)"
  default     = 256
}

variable "task_memory" {
  type        = number
  description = "The amount of memory (in MiB) used by the task. If using Fargate launch type `task_memory` must match [supported cpu value](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size)"
  default     = 512
}



######################################## container definition vars ########################################
variable "container_definition" {
  type        = map(any)
  description = "Container definition overrides which allows for extra keys or overriding existing keys."
  default     = {}
}

variable "container_name" {
  type        = string
  description = <<-EOT
      optionally define a custom value for the container name parameter(Up to 255 characters ([a-z], [A-Z], [0-9], -, _ allowed)
      By default, it is defined as a construction from var.labels
    EOT
  default     = "default"
}

variable "container_image" {
  type        = string
  description = "The image used to start the container. Images in the Docker Hub registry available by default"
}

variable "essential" {
  type        = bool
  description = "Determines whether all other containers in a task are stopped, if this container fails or stops for any reason. Due to how Terraform type casts booleans in json it is required to double quote this value"
  default     = true
}

variable "container_cpu" {
  type        = number
  description = "The number of cpu units to reserve for the container. This is optional for tasks using Fargate launch type and the total amount of container_cpu of all containers in a task will need to be lower than the task-level cpu value"
  default     = 0
}

variable "container_memory" {
  type        = number
  description = "The amount of memory (in MiB) to allow the container to use. This is a hard limit, if the container attempts to exceed the container_memory, the container is killed. This field is optional for Fargate launch type and the total amount of container_memory of all containers in a task will need to be lower than the task memory value"
  default     = null
}

variable "port_mappings" {
  type = list(object({
    containerPort = number
    hostPort      = number
    protocol      = string
  }))

  description = <<-EOT
      The port mappings to configure for the container. This is a list of maps.
      Each map should contain \"containerPort\", \"hostPort\", and \"protocol\",
      where \"protocol\" is one of \"tcp\" or \"udp\".
      If using containers in a task with the awsvpc or host network mode,
      the hostPort can either be left blank or set to the same value as the containerPort
    EOT

  default = []
}

variable "log_configuration" {
  description = "Log configuration option"
  default     = true
}

variable "environment" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "The environment variables to pass to the container. This is a list of maps. map_environment overrides environment"
  default     = []
}

variable "entrypoint" {
  type        = list(string)
  description = "The entry point that is passed to the container"
  default     = null
}

variable "command" {
  type        = list(string)
  description = "The command that is passed to the container"
  default     = null
}

variable "working_directory" {
  type        = string
  description = "The working directory to run commands inside the container"
  default     = null
}

variable "readonly_root_filesystem" {
  type        = bool
  description = "Determines whether a container is given read-only access to its root filesystem. Due to how Terraform type casts booleans in json it is required to double quote this value"
  default     = false
}

variable "mount_points" {
  type = list(object({
    containerPath = string
    sourceVolume  = string
    readOnly      = bool
  }))

  description = "Container mount points. This is a list of maps, where each map should contain `containerPath`, `sourceVolume` and `readOnly`"
  default     = []
}
