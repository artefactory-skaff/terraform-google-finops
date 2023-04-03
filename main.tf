/*
* # terraform-google-finops
*
* This Terraform module allows you to configure and deploy:
* - BigQuery quotas and quotas alerts.
* - Project budgets and budgets alerts.
*
* ## Usage
*
* ### Minimal BQ quotas
* ```hcl
* resource "google_monitoring_notification_channel" "basic" {
*   display_name = "Test Notification Channel"
*   type         = "email"
*   labels = {
*     email_address = "fake_email@blahblah.com"
*   }
*   force_delete = false
* }
*
* module "finops" {
*   source  = "artefactory/finops/google"
*   version = "~> 0.1"
*
*   quotas = {
*     bigquery_quota_tb_per_day_total    = 10  # 10 TiB Per day limit for the project
*     bigquery_quota_tb_per_day_per_user = 1  # 1 TiB Per day per user limit
*   }
* }
* ```
*
* ### BQ quotas with alerts
* ```hcl
* resource "google_monitoring_notification_channel" "basic" {
*   display_name = "Test Notification Channel"
*   type         = "email"
*   labels = {
*     email_address = "fake_email@blahblah.com"
*   }
*   force_delete = false
* }
*
* module "finops" {
*   source  = "artefactory/finops/google"
*   version = "~> 0.1"
*
*   quotas = {
*     bigquery_quota_tb_per_day_total    = 10  # 10 TiB Per day limit for the project
*     bigquery_quota_tb_per_day_per_user = 1  # 1 TiB Per day per user limit
*
*     alerts = {
*       notification_channels = [google_monitoring_notification_channel.basic.id]
*
*       # Send an alert when 80% of `bigquery_quota_tb_per_day_total` is reached
*       bigquery_quota_tb_per_day_total_threshold_ratio = 0.8
*
*       # Send an alert when 50% of `bigquery_quota_tb_per_day_per_user` is reached
*       bigquery_quota_tb_per_day_per_user_threshold_ratio = 0.5
*     }
*   }
* }
* ```
*
* ### BQ budgets with alerts
*
* ⚠️ This requires the principals (you and/or a service account) executing this code to be `roles/billing.costsManager` on the billing account used.
* ```hcl
* resource "google_monitoring_notification_channel" "basic" {
*   display_name = "Test Notification Channel"
*   type         = "email"
*   labels = {
*     email_address = "fake_email@blahblah.com"
*   }
*   force_delete = false
* }
*
* module "finops" {
*   source  = "artefactory/finops/google"
*   version = "~> 0.1"
*
*   budgets = {
*     billing_account_id = "ABCDEF-ABCDEF-ABCDEF"
*
*     # Configure a $200 USD budget for the project with alerts at 80% actual consumption and 200% forecasted consumption.
*     absolute_amount = {
*       amount = 200
*       alerts = {
*         notification_channels          = [google_monitoring_notification_channel.basic.id]
*
*         # Send an alert when 80% of the month's budget has been consumed.
*         current_threshold_ratio        = 0.8
*
*         # Send an alert when the forecasted spend at the end of the period is greater than 200% of the budget.
*         forecasted_threshold_ratio     = 2
*       }
*     }
*
*     # Configure a budget based on the last month's spend.
*     relative_amount = {
*       alerts = {
*         notification_channels          = [google_monitoring_notification_channel.basic.id]
*
*         # Send an alert when the spend for this month has increased more than 20% compared to last month.
*         current_threshold_ratio        = 1.2
*       }
*     }
*   }
* }
* ```
*
*/