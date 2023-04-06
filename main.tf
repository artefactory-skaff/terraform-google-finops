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
* locals {
*   project_id = "PROJECT_ID"  # Replace this with your actual project id
* }
*
* provider "google" {
*   user_project_override = true
*   billing_project       = local.project_id
* }
*
* # This is only required if you want to send alerts.
* # You can send different types of alerts besides email (Slack, Teams, SMS...): see https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel
* resource "google_monitoring_notification_channel" "email" {
*   project      = local.project_id
*   display_name = "Test Notification Channel"
*   type         = "email"
*   labels = {
*     email_address = "fake_email@blahblah.com"  # Change this to the email alerts will be sent to
*   }
*   force_delete = false
* }
*
* module "finops" {
*   source  = "artefactory/finops/google"
*   version = "~> 0.1"
*
*   project_id = local.project_id
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
* locals {
*   project_id = "PROJECT_ID"  # Replace this with your actual project id
* }
*
* provider "google" {
*   user_project_override = true
*   billing_project       = local.project_id
* }
*
* # This is only required if you want to send alerts.
* # You can send different types of alerts besides email (Slack, Teams, SMS...): see https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel
* resource "google_monitoring_notification_channel" "email" {
*   project      = local.project_id
*   display_name = "Test Notification Channel"
*   type         = "email"
*   labels = {
*     email_address = "fake_email@blahblah.com"  # Change this to the email alerts will be sent to
*   }
*   force_delete = false
* }
*
* module "finops" {
*   source  = "artefactory/finops/google"
*   version = "~> 0.1"
*
*   project_id = local.project_id
*
*   quotas = {
*     bigquery_quota_tb_per_day_total    = 10  # 10 TiB Per day limit for the project
*     bigquery_quota_tb_per_day_per_user = 1  # 1 TiB Per day per user limit
*
*     alerts = {
*       notification_channels = [google_monitoring_notification_channel.email.id]
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
* locals {
*   project_id = "PROJECT_ID"  # Replace this with your actual project id
* }
*
* provider "google" {
*   user_project_override = true
*   billing_project       = local.project_id
* }
*
* # This is only required if you want to send alerts.
* # You can send different types of alerts besides email (Slack, Teams, SMS...): see https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel
* resource "google_monitoring_notification_channel" "email" {
*   project      = local.project_id
*   display_name = "Test Notification Channel"
*   type         = "email"
*   labels = {
*     email_address = "fake_email@blahblah.com"  # Change this to the email alerts will be sent to
*   }
*   force_delete = false
* }
*
* module "finops" {
*   source  = "artefactory/finops/google"
*   version = "~> 0.1"
*
*   project_id = local.project_id
*
*   budgets = {
*     billing_account_id = "ABCDEF-ABCDEF-ABCDEF"  # Replace this with the billing account ID of your project https://console.cloud.google.com/billing/projects
*
*     # Configure a $200 USD budget for the project with alerts at 80% actual consumption and 200% forecasted consumption.
*     absolute_amount = {
*       amount = 200
*       alerts = {
*         notification_channels          = [google_monitoring_notification_channel.email.id]
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
*         notification_channels          = [google_monitoring_notification_channel.email.id]
*
*         # Send an alert when the spend for this month has increased more than 20% compared to last month.
*         current_threshold_ratio        = 1.2
*       }
*     }
*   }
* }
* ```
*/