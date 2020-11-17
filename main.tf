# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE ROL
# ---------------------------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid = ""
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.project_name}-myEcsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE cluster
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE template_file
# ---------------------------------------------------------------------------------------------------------------------

data "template_file" "myapp" {
  template = file(var.template)
  vars = var.vars_template
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-${var.environment}"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  container_definitions    = data.template_file.myapp.rendered
}

resource "aws_ecs_service" "main" {
  name            = "${var.project_name}-${var.environment}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = var.security_groups
    subnets          = var.subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.targetGroup_id
    container_name   = "${var.project_name}-${var.environment}"
    container_port   = 80
  }

  depends_on = [var.alb_frontend_id, aws_iam_role_policy_attachment.ecs_task_execution_role]
}
