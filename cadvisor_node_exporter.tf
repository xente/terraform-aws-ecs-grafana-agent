resource "aws_ecs_task_definition" "cadvisor_node_exporter" {
  family = "monitoring_cadvisor_node_exporter"

  container_definitions = jsonencode([
    {
      name      = "cadvisor"
      image     = var.cadvisor_docker_image
      cpu       = 0
      memory    = 300
      essential = true
      portMappings = [
        {
          hostPort      = 8080,
          protocol      = "tcp",
          containerPort = 8080
        }
      ]
      mountPoints = [
        {
          readOnly      = true
          containerPath = "/rootfs",
          sourceVolume  = "root"
        },
        {
          readOnly      = false
          containerPath = "/var/run",
          sourceVolume  = "var_run"
        },
        {
          readOnly      = true
          containerPath = "/sys",
          sourceVolume  = "sys"
        },
        {
          readOnly      = true
          containerPath = "/var/lib/docker",
          sourceVolume  = "var_lib_docker"
        }
      ],
      dockerLabels = {
        "PROMETHEUS_EXPORTER_PORT" : "8080"
      }
    },
    {
      name      = var.node_exporter_docker_image
      image     = "prom/node-exporter"
      cpu       = 0
      memory    = 300
      essential = true
      portMappings = [
        {
          hostPort      = 9100,
          protocol      = "tcp",
          containerPort = 9100
        }
      ],
      dockerLabels = {
        "PROMETHEUS_EXPORTER_PORT" : "9100"
      }
    }

  ])

  volume {
    name      = "root"
    host_path = "/"
  }

  volume {
    name      = "var_run"
    host_path = "/var/run"
  }

  volume {
    name      = "sys"
    host_path = "/sys"
  }

  volume {
    name      = "var_lib_docker"
    host_path = "/var/lib/docker/"
  }
}

resource "aws_ecs_service" "cadvisor_node_exporter" {
  name                = "cadvisor_node_exporter"
  cluster             = var.ecs_cluster_id
  task_definition     = aws_ecs_task_definition.cadvisor_node_exporter.arn
  scheduling_strategy = "DAEMON"
}