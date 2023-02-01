resource "aws_autoscaling_group" "this" {
  name                  = "${var.name}-grafana-agent"
  vpc_zone_identifier   = var.vpc_subnets
  protect_from_scale_in = var.protect_from_scale_in
  default_cooldown      = 10

  max_size         = var.asg_agent_capacity.max_size
  desired_capacity = var.asg_agent_capacity.desired_capacity
  min_size         = var.asg_agent_capacity.min_size


  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-grafana-agent"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }

}

resource "aws_ecs_capacity_provider" "this" {
  name = "${var.name}-grafana-agent"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.this.arn
    managed_termination_protection = var.protect_from_scale_in ? "ENABLED" : "DISABLED"

    managed_scaling {
      instance_warmup_period = 300
      status                 = "ENABLED"
      target_capacity        = 100
    }
  }
}