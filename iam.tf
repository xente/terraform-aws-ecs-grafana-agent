###Ecs Instance Profile Sequence####
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.name}-ecs-agent-profile"
  role = aws_iam_role.ecs_instance.name
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_instance" {
  name = "${var.name}-ecs-instance-role"
  path = "/grafana/ecs/"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  managed_policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  ]

  inline_policy {
    name   = "s3-resources-reader"
    policy = data.aws_iam_policy_document.s3_resources_access.json
  }

}

data "aws_iam_policy_document" "s3_resources_access" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.resources.arn, "${aws_s3_bucket.resources.arn}/*"
    ]
  }
}