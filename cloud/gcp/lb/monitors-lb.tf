#
# 4XX Errors
#
resource "datadog_monitor" "error_rate_4xx" {
  count   = "${var.error_rate_4xx_enabled ? 1 : 0}"
  name    = "[${var.environment}] GCP LB 4xx errors {{#is_alert}}{{{comparator}}} {{threshold}}% ({{value}}%){{/is_alert}}{{#is_warning}}{{{comparator}}} {{warn_threshold}}% ({{value}}%){{/is_warning}}"
  message = "${coalesce(var.error_rate_4xx_message, var.message)}"

  type = "metric alert"

  query = <<EOF
  ${var.error_rate_4xx_time_aggregator}(${var.error_rate_4xx_timeframe}):
    default(sum:gcp.loadbalancing.https.request_count{${var.filter_tags},response_code_class:400} by {forwarding_rule_name}.as_count(), 0)
    / (default(sum:gcp.loadbalancing.https.request_count{${var.filter_tags}} by {forwarding_rule_name}.as_count(), 0)
    + ${var.error_rate_4xx_artificial_request}) * 100
  > ${var.error_rate_4xx_threshold_critical}
EOF

  thresholds {
    warning  = "${var.error_rate_4xx_threshold_warning}"
    critical = "${var.error_rate_4xx_threshold_critical}"
  }

  notify_audit        = false
  locked              = false
  timeout_h           = 0
  include_tags        = true
  require_full_window = false
  notify_no_data      = false
  renotify_interval   = 0

  evaluation_delay = "${var.evaluation_delay}"
  new_host_delay   = "${var.new_host_delay}"

  silenced = "${var.error_rate_4xx_silenced}"

  tags = ["env:${var.environment}", "type:cloud", "provider:gcp", "resource:lb", "team:claranet", "created-by:terraform", "${var.error_rate_4xx_extra_tags}"]
}

#
# 5XX Errors
#
resource "datadog_monitor" "error_rate_5xx" {
  count   = "${var.error_rate_5xx_enabled ? 1 : 0}"
  name    = "[${var.environment}] GCP LB 5xx errors {{#is_alert}}{{{comparator}}} {{threshold}}% ({{value}}%){{/is_alert}}{{#is_warning}}{{{comparator}}} {{warn_threshold}}% ({{value}}%){{/is_warning}}"
  message = "${coalesce(var.error_rate_5xx_message, var.message)}"

  type = "metric alert"

  query = <<EOF
  ${var.error_rate_5xx_time_aggregator}(${var.error_rate_5xx_timeframe}):
    default(sum:gcp.loadbalancing.https.request_count{${var.filter_tags},response_code_class:500} by {forwarding_rule_name}.as_count(), 0)
    / (default(sum:gcp.loadbalancing.https.request_count{${var.filter_tags}} by {forwarding_rule_name}.as_count(), 0)
    + ${var.error_rate_5xx_artificial_request}) * 100
  > ${var.error_rate_5xx_threshold_critical}
EOF

  thresholds {
    warning  = "${var.error_rate_5xx_threshold_warning}"
    critical = "${var.error_rate_5xx_threshold_critical}"
  }

  notify_audit        = false
  locked              = false
  timeout_h           = 0
  include_tags        = true
  require_full_window = false
  notify_no_data      = false
  renotify_interval   = 0

  evaluation_delay = "${var.evaluation_delay}"
  new_host_delay   = "${var.new_host_delay}"

  silenced = "${var.error_rate_5xx_silenced}"

  tags = ["env:${var.environment}", "type:cloud", "provider:gcp", "resource:lb", "team:claranet", "created-by:terraform", "${var.error_rate_5xx_extra_tags}"]
}

#
# Backend Latency for service
#
resource "datadog_monitor" "backend_latency_service" {
  count   = "${var.backend_latency_service_enabled ? 1 : 0}"
  name    = "[${var.environment}] GCP LB service backend latency {{#is_alert}}{{{comparator}}} {{threshold}}ms ({{value}}ms){{/is_alert}}{{#is_warning}}{{{comparator}}} {{warn_threshold}}ms ({{value}}ms){{/is_warning}}"
  message = "${coalesce(var.backend_latency_service_message, var.message)}"

  type = "metric alert"

  query = <<EOF
  ${var.backend_latency_service_time_aggregator}(${var.backend_latency_service_timeframe}):
    default(min:gcp.loadbalancing.https.backend_latencies.avg{${var.filter_tags},backend_target_type:backend_service} by {backend_target_name,forwarding_rule_name}, 0)
  > ${var.backend_latency_service_threshold_critical}
EOF

  thresholds {
    warning  = "${var.backend_latency_service_threshold_warning}"
    critical = "${var.backend_latency_service_threshold_critical}"
  }

  notify_audit        = false
  locked              = false
  timeout_h           = 0
  include_tags        = true
  require_full_window = false
  notify_no_data      = false
  renotify_interval   = 0

  evaluation_delay = "${var.evaluation_delay}"
  new_host_delay   = "${var.new_host_delay}"

  silenced = "${var.backend_latency_service_silenced}"

  tags = ["env:${var.environment}", "type:cloud", "provider:gcp", "resource:lb", "team:claranet", "created-by:terraform", "${var.backend_latency_service_extra_tags}"]
}

#
# Backend Latency for bucket
#
resource "datadog_monitor" "backend_latency_bucket" {
  count   = "${var.backend_latency_bucket_enabled ? 1 : 0}"
  name    = "[${var.environment}] GCP LB bucket backend latency {{#is_alert}}{{{comparator}}} {{threshold}}ms ({{value}}ms){{/is_alert}}{{#is_warning}}{{{comparator}}} {{warn_threshold}}ms ({{value}}ms){{/is_warning}}"
  message = "${coalesce(var.backend_latency_bucket_message, var.message)}"

  type = "metric alert"

  query = <<EOF
  ${var.backend_latency_bucket_time_aggregator}(${var.backend_latency_bucket_timeframe}):
    default(min:gcp.loadbalancing.https.backend_latencies.avg{${var.filter_tags},backend_target_type:backend_bucket} by {backend_target_name,forwarding_rule_name}, 0)
  > ${var.backend_latency_bucket_threshold_critical}
EOF

  thresholds {
    warning  = "${var.backend_latency_bucket_threshold_warning}"
    critical = "${var.backend_latency_bucket_threshold_critical}"
  }

  notify_audit        = false
  locked              = false
  timeout_h           = 0
  include_tags        = true
  require_full_window = false
  notify_no_data      = false
  renotify_interval   = 0

  evaluation_delay = "${var.evaluation_delay}"
  new_host_delay   = "${var.new_host_delay}"

  silenced = "${var.backend_latency_bucket_silenced}"

  tags = ["env:${var.environment}", "type:cloud", "provider:gcp", "resource:lb", "team:claranet", "created-by:terraform", "${var.backend_latency_bucket_extra_tags}"]
}

#
# Request Count
#
resource "datadog_monitor" "request_count" {
  count   = "${var.request_count_enabled ? 1 : 0}"
  name    = "[${var.environment}] GCP LB Requests count increased abruptly {{#is_alert}}{{value}}%{{/is_alert}}{{#is_warning}}{{value}}%{{/is_warning}}"
  message = "${coalesce(var.request_count_message, var.message)}"

  type = "query alert"

  query = <<EOF
  pct_change(${var.request_count_time_aggregator}(${var.request_count_timeframe}),${var.request_count_timeshift}):
  default(sum:gcp.loadbalancing.https.request_count{${var.filter_tags}} by {forwarding_rule_name}.as_count(), 0)
  > ${var.request_count_threshold_critical}
EOF

  thresholds {
    warning  = "${var.request_count_threshold_warning}"
    critical = "${var.request_count_threshold_critical}"
  }

  notify_audit        = false
  locked              = false
  timeout_h           = 0
  include_tags        = true
  require_full_window = false
  notify_no_data      = false
  renotify_interval   = 0

  evaluation_delay = "${var.evaluation_delay}"
  new_host_delay   = "${var.new_host_delay}"

  silenced = "${var.request_count_silenced}"

  tags = ["env:${var.environment}", "type:cloud", "provider:gcp", "resource:lb", "team:claranet", "created-by:terraform", "${var.request_count_extra_tags}"]
}