# Grafana Cloud Agent for ECS

Terraform module which integrate Grafana Agent into existent ECS Cluster

## Usage

```hcl

module "grafana_agnet" {

  source  = "xente/ecs-grafana-agent/aws"
  version = "0.1.0"
  
  name = "my-grafana-agent"
  ecs_cluster_id = aws_ecs_cluster.current.id
  grafana_credentials_username  = "MY_USER"
  grafana_credentials_password = "MY_PASSWORD"
  vpc_subnets =  [aws_subnet.main.id]
}


resource "aws_ecs_cluster" "sample" {
  name = "${local.stack}-sample"
}

resource "aws_ecs_cluster_capacity_providers" "sample" {
  cluster_name       = aws_ecs_cluster.sample.name
  capacity_providers = [module.grafana_agnet.ecs_agent_capacity_provider_name]
}


```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.73 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.73 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_ecs_capacity_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_service.agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_service.cadvisor_node_exporter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.cadvisor_node_exporter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.grafana_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_instance_profile.ecs_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ecs_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.grafana_agent_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.grafana_agent_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_s3_bucket.resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_object.agent_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_ami.amazon_linux_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.ec2_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.grafana_agent_discovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.grafana_agent_tasks_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_resources_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ecs_cluster_id"></a> [ecs\_cluster\_id](#input\_ecs\_cluster\_id) | Id of the ECS cluster where Agent has to be deployed | `string` | n/a | yes |
| <a name="input_grafana_credentials_password"></a> [grafana\_credentials\_password](#input\_grafana\_credentials\_password) | Grafanan credentials | `string` | n/a | yes |
| <a name="input_grafana_credentials_username"></a> [grafana\_credentials\_username](#input\_grafana\_credentials\_username) | Grafana username | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | n/a | yes |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets) | (Required) List of one or more availability subnets where Grafana Agent ASG has to allocate the instances | `list(string)` | n/a | yes |
| <a name="input_agent_service_desired_count"></a> [agent\_service\_desired\_count](#input\_agent\_service\_desired\_count) | (Optional) Desired agent service replicas | `number` | `1` | no |
| <a name="input_asg_agent_capacity"></a> [asg\_agent\_capacity](#input\_asg\_agent\_capacity) | (Optional) Capacity of the ASG for the agent | `map(number)` | <pre>{<br>  "desired_capacity": 1,<br>  "max_size": 1,<br>  "min_size": 1<br>}</pre> | no |
| <a name="input_cadvisor_docker_image"></a> [cadvisor\_docker\_image](#input\_cadvisor\_docker\_image) | (Optional) Cadvisor Docker image | `string` | `"google/cadvisor"` | no |
| <a name="input_grafana_agent_docker_image"></a> [grafana\_agent\_docker\_image](#input\_grafana\_agent\_docker\_image) | (Optional) Grafana Agent Docker image | `string` | `"grafana/agent"` | no |
| <a name="input_grafana_agent_keep_label_regex"></a> [grafana\_agent\_keep\_label\_regex](#input\_grafana\_agent\_keep\_label\_regex) | (Optional) Filter out targets and metrics based on whether our label values match the provided regex. | `string` | `"node_disk_bytes_read|node_cpu_utilisation|node_memory_utilisation|container_last_seen|job|cadvisor_version_info|prometheus_build_info|node_exporter_build_info|container_cpu_user_seconds_total|apiserver_request_total|container_last_see|container_cpu_system_seconds_total|container_cpu_usage_seconds_total|node_filesystem_avail_bytes|node_cpu_seconds_total|scheduler_binding_duration_seconds_bucket|container_network_transmit_bytes_total|process_resident_memory_bytes|container_network_receive_packets_dropped_total|scheduler_binding_duration_seconds_count|scheduler_volume_scheduling_duration_seconds_bucket|workqueue_queue_duration_seconds_bucket|container_network_transmit_packets_total|rest_project_request_duration_seconds_bucket|container_cpu_cfs_throttled_periods_total|cluster_quantile:apiserver_request_duration_seconds:histogram_quantile|container_memory_cache|go_goroutines|rest_project_requests_total|container_memory_swap|storage_operation_errors_total|scheduler_e2e_scheduling_duration_seconds_bucket|container_network_transmit_packets_dropped_total|storage_operation_duration_seconds_count|node_netstat_TcpExt_TCPSynRetrans|node_netstat_Tcp_OutSegs|container_cpu_cfs_periods_total|container_network_receive_bytes_total|node_netstat_Tcp_RetransSegs|up|storage_operation_duration_seconds_bucket|scheduler_scheduling_algorithm_duration_seconds_bucket|code_resource:apiserver_request_total:rate5m|process_cpu_seconds_total|container_memory_usage_bytes|workqueue_adds_total|container_network_receive_packets_total|container_memory_working_set_bytes|scheduler_scheduling_algorithm_duration_seconds_count|apiserver_request:availability30d|container_memory_rss|scheduler_e2e_scheduling_duration_seconds_count|scheduler_volume_scheduling_duration_seconds_count|workqueue_depth|:node_memory_MemAvailable_bytes:sum|volume_manager_total_volumes"` | no |
| <a name="input_grafana_credentials_push_url"></a> [grafana\_credentials\_push\_url](#input\_grafana\_credentials\_push\_url) | Remote Prometheus Write Endpoint | `string` | `"https://prometheus-prod-01-eu-west-0.grafana.net/api/prom/push"` | no |
| <a name="input_launch_instance_type_agent"></a> [launch\_instance\_type\_agent](#input\_launch\_instance\_type\_agent) | (Optional) Instance type to use for the instance | `string` | `"t3.small"` | no |
| <a name="input_node_exporter_docker_image"></a> [node\_exporter\_docker\_image](#input\_node\_exporter\_docker\_image) | (Optional) Node Exporter Docker image | `string` | `"node-exporter"` | no |
| <a name="input_protect_from_scale_in"></a> [protect\_from\_scale\_in](#input\_protect\_from\_scale\_in) | (Optional) Whether newly launched instances are automatically protected from termination by Amazon EC2 Auto Scaling when scaling in. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_agent_capacity_provider_name"></a> [ecs\_agent\_capacity\_provider\_name](#output\_ecs\_agent\_capacity\_provider\_name) | Capacity provider to be added into ECS cluster |
| <a name="output_ecs_agent_service_name"></a> [ecs\_agent\_service\_name](#output\_ecs\_agent\_service\_name) | Grafana ECS services name |
<!-- END_TF_DOCS -->