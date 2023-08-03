resource "shoreline_notebook" "haproxy_backend_response_time_is_above_500ms_for_host" {
  name       = "haproxy_backend_response_time_is_above_500ms_for_host"
  data       = file("${path.module}/data/haproxy_backend_response_time_is_above_500ms_for_host.json")
  depends_on = [shoreline_action.invoke_cpu_usage_check,shoreline_action.invoke_high_memory_usage_check,shoreline_action.invoke_ping_check,shoreline_action.invoke_sysctl_performance_settings]
}

resource "shoreline_file" "cpu_usage_check" {
  name             = "cpu_usage_check"
  input_file       = "${path.module}/data/cpu_usage_check.sh"
  md5              = filemd5("${path.module}/data/cpu_usage_check.sh")
  description      = "Check CPU usage"
  destination_path = "/agent/scripts/cpu_usage_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "high_memory_usage_check" {
  name             = "high_memory_usage_check"
  input_file       = "${path.module}/data/high_memory_usage_check.sh"
  md5              = filemd5("${path.module}/data/high_memory_usage_check.sh")
  description      = "Check memory usage"
  destination_path = "/agent/scripts/high_memory_usage_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "ping_check" {
  name             = "ping_check"
  input_file       = "${path.module}/data/ping_check.sh"
  md5              = filemd5("${path.module}/data/ping_check.sh")
  description      = "Check network connectivity"
  destination_path = "/agent/scripts/ping_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "sysctl_performance_settings" {
  name             = "sysctl_performance_settings"
  input_file       = "${path.module}/data/sysctl_performance_settings.sh"
  md5              = filemd5("${path.module}/data/sysctl_performance_settings.sh")
  description      = "Tune the server's operating system parameters to improve performance"
  destination_path = "/agent/scripts/sysctl_performance_settings.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_cpu_usage_check" {
  name        = "invoke_cpu_usage_check"
  description = "Check CPU usage"
  command     = "`chmod +x /agent/scripts/cpu_usage_check.sh && /agent/scripts/cpu_usage_check.sh`"
  params      = []
  file_deps   = ["cpu_usage_check"]
  enabled     = true
  depends_on  = [shoreline_file.cpu_usage_check]
}

resource "shoreline_action" "invoke_high_memory_usage_check" {
  name        = "invoke_high_memory_usage_check"
  description = "Check memory usage"
  command     = "`chmod +x /agent/scripts/high_memory_usage_check.sh && /agent/scripts/high_memory_usage_check.sh`"
  params      = []
  file_deps   = ["high_memory_usage_check"]
  enabled     = true
  depends_on  = [shoreline_file.high_memory_usage_check]
}

resource "shoreline_action" "invoke_ping_check" {
  name        = "invoke_ping_check"
  description = "Check network connectivity"
  command     = "`chmod +x /agent/scripts/ping_check.sh && /agent/scripts/ping_check.sh`"
  params      = []
  file_deps   = ["ping_check"]
  enabled     = true
  depends_on  = [shoreline_file.ping_check]
}

resource "shoreline_action" "invoke_sysctl_performance_settings" {
  name        = "invoke_sysctl_performance_settings"
  description = "Tune the server's operating system parameters to improve performance"
  command     = "`chmod +x /agent/scripts/sysctl_performance_settings.sh && /agent/scripts/sysctl_performance_settings.sh`"
  params      = ["VALUE"]
  file_deps   = ["sysctl_performance_settings"]
  enabled     = true
  depends_on  = [shoreline_file.sysctl_performance_settings]
}

