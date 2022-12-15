data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  depends_on = [aws_iam_role.ecs_agent]
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  path = "/"
  role = aws_iam_role.ecs_agent.id
  provisioner "local-exec" {
    command = "sleep 60"
  }
}

resource "aws_launch_configuration" "ecs_launch_config" {

  image_id             = "ami-07383d4bda8b9c72b"
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = [aws_security_group.wordpress_instance_sg.id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=terraform-wordpress-cluster >> /etc/ecs/ecs.config;echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;"
  instance_type        = "t2.micro"
  ebs_optimized        = "false"
  key_name             = "terraform"
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {

  name                      = "asg"
  vpc_zone_identifier       = [aws_subnet.pub_subnet.id, aws_subnet.pub_subnet1.id]
  launch_configuration      = aws_launch_configuration.ecs_launch_config.name
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 10
  health_check_grace_period = 300
  health_check_type         = "EC2"
}


resource "aws_iam_role" "ecs-service-role" {
  name               = "ecs-service-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-service-policy.json
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
  role       = aws_iam_role.ecs-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs-service-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}
