resource "aws_iam_role" "role_for_the_ecs_tasks_task8" {
  name = "role_for_the_ecs_tasks_task8"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

# ECS Task Execution Policy to access ECR and CloudWatch Logs
resource "aws_iam_policy" "ecs_task_execution_policy_task8" {
  name        = "ecs_task_execution_policy_task8"
  description = "Policy for ECS task execution to access ECR and CloudWatch Logs"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ],
        "Resource": "*"
      }
    ]
  })
}

# ECS Exec permissions (SSM related)
resource "aws_iam_policy" "ecs_exec_policy_task8" {
  name        = "ecs_exec_policy_task8"
  description = "Policy for ECS Exec to enable exec into containers"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        "Resource": "*"
      }
    ]
  })
}

# Attach both the execution policy and exec policy to the role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment_task8" {
  policy_arn = aws_iam_policy.ecs_task_execution_policy_task8.arn
  role       = aws_iam_role.role_for_the_ecs_tasks_task8.name
}

resource "aws_iam_role_policy_attachment" "ecs_exec_policy_attachment_task8" {
  policy_arn = aws_iam_policy.ecs_exec_policy_task8.arn
  role       = aws_iam_role.role_for_the_ecs_tasks_task8.name
}
