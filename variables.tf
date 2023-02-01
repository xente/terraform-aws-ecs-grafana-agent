variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "ecs_cluster_id" {
  description = "Id of the ECS cluster where Agent has to be deployed"
  type        = string
}

variable "vpc_subnets" {
  type        = list(string)
  description = "(Required) List of one or more availability subnets where Grafana Agent ASG has to allocate the instances"
}

variable "grafana_credentials_username" {
  description = "Grafana username"
  type        = string
}

variable "grafana_credentials_password" {
  description = "Grafanan credentials"
  type        = string
}

variable "grafana_credentials_push_url" {
  description = "Remote Prometheus Write Endpoint"
  type        = string
  default     = "https://prometheus-prod-01-eu-west-0.grafana.net/api/prom/push"
}

variable "grafana_agent_keep_label_regex" {
  description = "(Optional) Filter out targets and metrics based on whether our label values match the provided regex."
  type        = string
  default     = "node_disk_bytes_read|node_cpu_utilisation|node_memory_utilisation|container_last_seen|job|cadvisor_version_info|prometheus_build_info|node_exporter_build_info|container_cpu_user_seconds_total|apiserver_request_total|container_last_see|container_cpu_system_seconds_total|container_cpu_usage_seconds_total|node_filesystem_avail_bytes|node_cpu_seconds_total|scheduler_binding_duration_seconds_bucket|container_network_transmit_bytes_total|process_resident_memory_bytes|container_network_receive_packets_dropped_total|scheduler_binding_duration_seconds_count|scheduler_volume_scheduling_duration_seconds_bucket|workqueue_queue_duration_seconds_bucket|container_network_transmit_packets_total|rest_project_request_duration_seconds_bucket|container_cpu_cfs_throttled_periods_total|cluster_quantile:apiserver_request_duration_seconds:histogram_quantile|container_memory_cache|go_goroutines|rest_project_requests_total|container_memory_swap|storage_operation_errors_total|scheduler_e2e_scheduling_duration_seconds_bucket|container_network_transmit_packets_dropped_total|storage_operation_duration_seconds_count|node_netstat_TcpExt_TCPSynRetrans|node_netstat_Tcp_OutSegs|container_cpu_cfs_periods_total|container_network_receive_bytes_total|node_netstat_Tcp_RetransSegs|up|storage_operation_duration_seconds_bucket|scheduler_scheduling_algorithm_duration_seconds_bucket|code_resource:apiserver_request_total:rate5m|process_cpu_seconds_total|container_memory_usage_bytes|workqueue_adds_total|container_network_receive_packets_total|container_memory_working_set_bytes|scheduler_scheduling_algorithm_duration_seconds_count|apiserver_request:availability30d|container_memory_rss|scheduler_e2e_scheduling_duration_seconds_count|scheduler_volume_scheduling_duration_seconds_count|workqueue_depth|:node_memory_MemAvailable_bytes:sum|volume_manager_total_volumes"
}

variable "grafana_agent_docker_image" {
  description = "(Optional) Grafana Agent Docker image"
  type        = string
  default     = "grafana/agent"
}

variable "cadvisor_docker_image" {
  description = "(Optional) Cadvisor Docker image"
  type        = string
  default     = "google/cadvisor"
}

variable "node_exporter_docker_image" {
  description = "(Optional) Node Exporter Docker image"
  type        = string
  default     = "node-exporter"
}

variable "agent_service_desired_count" {
  description = "(Optional) Desired agent service replicas"
  type        = number
  default     = 1
}

variable "asg_agent_capacity" {
  description = "(Optional) Capacity of the ASG for the agent"
  type        = map(number)
  default = {
    max_size         = 1,
    min_size         = 1,
    desired_capacity = 1
  }
}

variable "protect_from_scale_in" {
  description = "(Optional) Whether newly launched instances are automatically protected from termination by Amazon EC2 Auto Scaling when scaling in."
  type        = bool
  default     = true
}

variable "launch_instance_type_agent" {
  description = "(Optional) Instance type to use for the instance"
  type        = string
  default     = "t3.small"
}
