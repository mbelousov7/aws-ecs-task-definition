#################################################  <ENV>.tfvars  #################################################
# in the examples for modules, variables are defined and set in the same file as the module definition.
# This is done to better understand the meaning of the variables.
# In a real environment, you should define variables in a variables.tf, the values of variables depending on the environment in the <ENV name>.tfvars

variable "ENV" {
  type        = string
  description = "defines the name of the environment(dev, prod, etc). Should be defined as env variable, for example export TF_VAR_ENV=dev"
}

# in example using dev account
variable "account_number" {
  type    = string
  default = "12345678910"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "labels" {
  default = {
    prefix = "myproject"
    stack  = "stackName"
  }
}

variable "component" {
  default = "componentName"
}

variable "container_name" {
  default = "nginx"
}

variable "container_image" {
  default = "nginx:1.14.2"
}

variable "task_cpu" {
  default = 256
}

variable "task_memory" {
  default = 512
}

variable "task_role_policy_statements" {
  default = {
    policy-ec2 = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
    policy-s3 = [
      {
        Action = [
          "s3:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  }

}

variable "cloudteam_policy_names" {
  default = ["cloud-service-policy-global-deny-1", "cloud-service-policy-global-deny-2"]
}

# <ENV>.tfvars end
#################################################################################################################

#################################################  locals vars  #################################################
#if the value of a variable depends on the value of other variables, it should be defined in a locals block
locals {

  labels = merge(
    { env = var.ENV },
    { component = var.component },
    var.labels
  )

  container_environment = [
    {
      "name"  = "ENVIRONMENT",
      "value" = "${var.ENV}"
    },
    {
      "name"  = "CONFIG_PATH",
      "value" = "/etc/nginx/conf.txt"
    }
  ]

  cloudteam_policy_arns = formatlist("arn:aws:iam::${var.account_number}:policy/%s", var.cloudteam_policy_names)

}


#################################################  module config  #################################################
# In module parameters recommend use terraform variables, because:
# - values can be environment dependent
# - this ComponentName.tf file - is more for component logic description, not for values definition
# - it is better to store vars values in one or two places(<ENV>.tfvars file and variables.tf)
module "test_ecs_task_definition" {
  source                      = "../../"
  aws_region                  = var.region
  aws_account_number          = var.account_number
  container_name              = var.container_name
  container_image             = var.container_image
  task_cpu                    = var.task_cpu
  task_memory                 = var.task_memory
  environment                 = local.container_environment
  task_role_policy_arns       = local.cloudteam_policy_arns
  task_role_policy_statements = var.task_role_policy_statements
  labels                      = local.labels
}