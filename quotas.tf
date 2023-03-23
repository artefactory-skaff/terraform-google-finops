resource "google_service_usage_consumer_quota_override" "bigquery_query_total" {
  provider       = google-beta
  project        = var.project_id
  service        = "bigquery.googleapis.com"
  metric         = urlencode("bigquery.googleapis.com/quota/query/usage")
  limit          = urlencode("/d/project")
  override_value = "1048576" * var.quotas.bigquery_quota_tb_per_day_total
  force          = true
}

resource "google_service_usage_consumer_quota_override" "bigquery_query_user" {
  provider       = google-beta
  project        = var.project_id
  service        = "bigquery.googleapis.com"
  metric         = urlencode("bigquery.googleapis.com/quota/query/usage")
  limit          = urlencode("/d/project/user")
  override_value = "1048576" * var.quotas.bigquery_quota_tb_per_day_per_user
  force          = true
}