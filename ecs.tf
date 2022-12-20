# ---------------------------------------------------------
# TASK DEFINITION
# ---------------------------------------------------------

resource "aws_ecs_task_definition" "terraform_task" {
  family                   = "wordpress1"
  requires_compatibilities = ["EC2"]
  container_definitions = jsonencode([
    {
      name  = "${var.container_name}"
      image = "wordpress:latest"
      #   cpu       = 10
      memory    = 128
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 0
        }
      ]
      environment = [
        {
          "name" : "WORDPRESS_DB_HOST",
          "value" : aws_db_instance.terraform_rds.address

        },
        {
          "name" : "WORDPRESS_DB_NAME",
          "value" : "terraform_rds"
        },
        {
          "name" : "WORDPRESS_DB_PASSWORD",
          "value" : "${random_password.password.result}"
        },
        {
          "name" : "WORDPRESS_DB_USER",
          "value" : "${var.db_user}"
        }
      ]

    }
  ])
}

resource "aws_ecs_service" "worker" {
  name            = var.container_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.terraform_task.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.healthcheck.arn
    container_name   = var.container_name
    container_port   = 80
  }

}

