# Changelog

Make sure to update this file for each merge into *develop*, otherwise the build fails.
The build relies on the latest version in this file.
Latest versions must be at the top!

## [1.1.0] - 2023-05-26

- add var aws_account_number

## [1.0.3] - 2023-03-02

- add container_definition_name output

## [1.0.2] - 2022-04-26

- add dafault task_iam_role_default arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy
- add default container_name value
- rm not used var fargatetd_ecs_cluster_name
- add port_mappings option

## [1.0.1] - 2022-04-26

- fix: add task_iam_role_logging

## [1.0.0] - 2022-04-12

- add tf module, example, readme, gitlab-ci
