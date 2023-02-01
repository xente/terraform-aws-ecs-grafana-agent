data "aws_iam_policy_document" "grafana_agent_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "grafana_agent_execution_role" {
  name = "${var.name}-ecs-grafana-agent-execution-role"
  path = "/${var.name}/ecs/grafana-agent/"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]

  assume_role_policy = data.aws_iam_policy_document.grafana_agent_tasks_execution_role.json

}

resource "aws_iam_role" "grafana_agent_task_role" {
  name = "${var.name}-ecs-grafana-agent-role"
  path = "/${var.name}/ecs/grafana-agent/"

  assume_role_policy = data.aws_iam_policy_document.grafana_agent_tasks_execution_role.json

  inline_policy {
    name   = "${var.name}-grafana-agent-discovery"
    policy = data.aws_iam_policy_document.grafana_agent_discovery.json
  }
}

data "aws_iam_policy_document" "grafana_agent_discovery" {
  statement {
    actions = [
      "ecs:ListClusters",
      "ecs:ListTasks",
      "ecs:DescribeTask",
      "ec2:DescribeInstances",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeTasks",
      "ecs:DescribeTaskDefinition"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_ecs_task_definition" "grafana_agent" {
  family = "monitoring_grafana_agent"

  container_definitions = jsonencode([
    {
      name      = "grafana-agent"
      image     = var.grafana_agent_docker_image
      cpu       = 0
      memory    = 128
      essential = true
      mountPoints = [
        {
          containerPath = "/output",
          sourceVolume  = "config"
        },
        {
          containerPath = "/etc/agent/agent.yaml",
          sourceVolume  = "agent_config"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" : "/ecs/grafana-agent-ecs",
          "awslogs-region" : data.aws_region.current.name,
          "awslogs-stream-prefix" : "ecs"
        }
      }
    },
    {
      name      = "prometheus-ecs-discovery"
      image     = "tkgregory/prometheus-ecs-discovery:latest"
      cpu       = 0
      memory    = 128
      essential = true
      mountPoints = [
        {
          containerPath = "/output",
          sourceVolume  = "config"
        }
      ]
      command = [
        "-config.write-to=/output/ecs_file_sd.yml",
        "-config.scrape-interval=1s"
      ]
      environment = [
        {
          "name" : "AWS_REGION",
          "value" : data.aws_region.current.name
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" : "/ecs/grafana-agent-ecs",
          "awslogs-region" : data.aws_region.current.name,
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }

  ])

  volume {
    name      = "agent_config"
    host_path = "/ecs/monitoring-resources/agent.yaml"
  }

  volume {
    name = "config"
  }

  requires_compatibilities = [
    "EC2",
  ]

  task_role_arn      = aws_iam_role.grafana_agent_task_role.arn
  execution_role_arn = aws_iam_role.grafana_agent_execution_role.arn
}

resource "aws_ecs_service" "agent" {
  name            = "grafana_agent"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.grafana_agent.arn
  desired_count   = var.agent_service_desired_count

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    weight            = 1
  }

  placement_constraints {
    type = "distinctInstance"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}