resource "aws_s3_bucket" "resources" {
  bucket = local.monitoring_resources
}

resource "aws_s3_object" "agent_config" {
  bucket         = aws_s3_bucket.resources.id
  key            = "/monitoring-resources/agent.yaml"
  content_base64 = base64encode(templatefile("${path.module}/resources/agent.yaml", { url = var.grafana_credentials_push_url, username = var.grafana_credentials_username, password = var.grafana_credentials_password, keep_label_regex = var.grafana_agent_keep_label_regex }))
  etag           = filemd5("${path.module}/resources/agent.yaml")
}

