resource "aws_launch_template" "this" {
  name          = "${var.name}-ecs-grafana-agent"
  image_id      = data.aws_ami.amazon_linux_ecs.id
  instance_type = var.launch_instance_type_agent

  instance_initiated_shutdown_behavior = "terminate"

  ebs_optimized = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = "gp3"
      delete_on_termination = "true"
      encrypted             = "false"
      iops                  = 3000
    }
  }

  instance_market_options {
    market_type = "spot"
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs_instance_profile.arn
  }

  user_data = base64encode(templatefile("${path.module}/templates/user-data.tftpl", {
    ecs_cluster  = var.ecs_cluster_id,
    s3_resources = aws_s3_bucket.resources.id
  }))
}