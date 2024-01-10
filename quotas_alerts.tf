resource "google_monitoring_alert_policy" "bigquery_query_total_quota_alert" {
  count = try(var.quotas.alerts.bigquery_quota_tb_per_day_total_threshold_ratio, null) != null ? 1 : 0

  project      = var.project_id
  display_name = "Bigquery project quota alert"
  combiner     = "OR"

  conditions {
    display_name = "BigQuery query project quota alert"
    condition_monitoring_query_language {
      duration = "300s"
      query    = "fetch consumer_quota |filter resource.project_id=='${var.project_id}'|{metric serviceruntime.googleapis.com/quota/rate/net_usage|filter metric.quota_metric=='bigquery.googleapis.com/quota/query/usage'|map add [metric.limit_name: 'QueryUsagePerDay']|map add [day: end().timestamp_to_string('%Y%m%d', 'America/Los_Angeles').string_to_int64]|group_by 1d,.sum|map add [current_day: end().timestamp_to_string('%Y%m%d', 'America/Los_Angeles').string_to_int64]|group_by [resource.project_id,resource.service,metric.quota_metric,metric.limit_name];metric serviceruntime.googleapis.com/quota/limit|filter metric.quota_metric=='bigquery.googleapis.com/quota/query/usage'&&metric.limit_name=='QueryUsagePerDay'|group_by [resource.project_id,resource.service,metric.quota_metric,metric.limit_name],.min}|ratio|window 1d|every 30s|condition gt(val(), ${var.quotas.alerts.bigquery_quota_tb_per_day_total_threshold_ratio} '1')"
    }
  }

  documentation {
    content   = "${var.project_id} Reached ${var.quotas.bigquery_quota_tb_per_day_total * var.quotas.alerts.bigquery_quota_tb_per_day_total_threshold_ratio}TB out of ${var.quotas.bigquery_quota_tb_per_day_total}TB of the daily BigQuery quota (${var.quotas.alerts.bigquery_quota_tb_per_day_total_threshold_ratio * 100}%)"
    mime_type = "text/markdown"
  }

  notification_channels = var.quotas.alerts.notification_channels
}

resource "google_monitoring_alert_policy" "bigquery_query_user_quota_alert" {
  count = try(var.quotas.alerts.bigquery_quota_tb_per_day_per_user_threshold_ratio, null) != null ? 1 : 0

  project      = var.project_id
  display_name = "Bigquery user quota alert"
  combiner     = "OR"

  conditions {
    display_name = "BigQuery query user quota alert"
    condition_monitoring_query_language {
      duration = "300s"
      query    = "fetch consumer_quota |filter resource.project_id=='${var.project_id}'|{metric serviceruntime.googleapis.com/quota/rate/net_usage|filter metric.quota_metric=='bigquery.googleapis.com/quota/query/usage'|map add [metric.limit_name: 'QueryUsagePerUserPerDay']|map add [day: end().timestamp_to_string('%Y%m%d', 'America/Los_Angeles').string_to_int64]|group_by 1d,.sum|map add [current_day: end().timestamp_to_string('%Y%m%d', 'America/Los_Angeles').string_to_int64]|group_by [resource.project_id,resource.service,metric.quota_metric,metric.limit_name];metric serviceruntime.googleapis.com/quota/limit|filter metric.quota_metric=='bigquery.googleapis.com/quota/query/usage'&&metric.limit_name=='QueryUsagePerUserPerDay'|group_by [resource.project_id,resource.service,metric.quota_metric,metric.limit_name],.min}|ratio|window 1d|every 30s|condition gt(val(), ${var.quotas.alerts.bigquery_quota_tb_per_day_per_user_threshold_ratio} '1')"
    }
  }

  documentation {
    content   = "A user on ${var.project_id} Reached ${var.quotas.bigquery_quota_tb_per_day_per_user * var.quotas.alerts.bigquery_quota_tb_per_day_per_user_threshold_ratio}TB out of ${var.quotas.bigquery_quota_tb_per_day_per_user}TB of the daily BigQuery quota (${var.quotas.alerts.bigquery_quota_tb_per_day_per_user_threshold_ratio * 100}%)"
    mime_type = "text/markdown"
  }

  notification_channels = var.quotas.alerts.notification_channels
}