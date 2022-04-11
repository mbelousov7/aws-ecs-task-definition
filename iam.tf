locals {

  task_iam_role = var.task_iam_role == "default" ? (
    "${var.labels.prefix}-${var.labels.stack}-${var.labels.component}-task-iam-role-${var.labels.env}"
  ) : var.task_iam_role

}

# IAM role that the Amazon ECS container agent and the Docker daemon can assume
data "aws_iam_policy_document" "task_iam" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_iam_role" {
  name                 = local.task_iam_role
  assume_role_policy   = join("", data.aws_iam_policy_document.task_iam.*.json)
  permissions_boundary = var.permissions_boundary == "" ? null : var.permissions_boundary
  tags = merge(
    var.labels,
    var.tags,
    { Name = local.task_iam_role }
  )
}

resource "aws_iam_role_policy" "task_iam_role" {
  for_each = var.task_role_policy_statements
  name     = "${local.task_iam_role}-${each.key}"
  role     = aws_iam_role.task_iam_role.id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = each.value
  })
}

resource "aws_iam_role_policy_attachment" "task_iam_role" {
  for_each   = toset(var.task_role_policy_arns)
  role       = aws_iam_role.task_iam_role.name
  policy_arn = each.key
}