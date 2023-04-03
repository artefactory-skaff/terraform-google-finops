resource "google_monitoring_notification_channel" "email" {
  display_name = "Test Notification Channel"
  type         = "email"
  labels = {
    email_address = "fake_email@blahblah.com"
  }
  force_delete = false
}

module "finops" {
  source  = "artefactory/finops/google"
  version = "~> 0.1"

  # Replace this with your actual project id
  project_id = "PROJECT_ID"

  #  quotas = {
  ##    # Set a 10 TiB Per day limit for the project
  ##    bigquery_quota_tb_per_day_total = 10
  #
  ##    # Set 1 TiB Per day per user limit for the project
  ##    bigquery_quota_tb_per_day_per_user = 1
  #
  ##    alerts = {
  ##      notification_channels = [google_monitoring_notification_channel.email.id]
  ##
  ###      # Send an alert when 80% of `bigquery_quota_tb_per_day_total` is reached
  ###      bigquery_quota_tb_per_day_total_threshold_ratio = 0.8
  ##
  ###      # Send an alert when 50% of `bigquery_quota_tb_per_day_per_user` is reached
  ###      bigquery_quota_tb_per_day_per_user_threshold_ratio = 0.5
  ##    }
  #  }

  #  budgets = {
  #    billing_account_id = "ABCDEF-ABCDEF-ABCDEF"
  #
  ##    # Configure a $200 USD budget for the project with alerts at 80% actual consumption and 200% forecasted consumption.
  ##    absolute_amount = {
  ##
  ##      # Dollar amount for the budget.
  ##      amount = 200
  ##
  ##      # Define budget alerts thresholds and where they will be sent.
  ##      alerts = {
  ##        notification_channels = [google_monitoring_notification_channel.email.id]
  ##
  ###        # Send an alert when 80% of the month's budget has been consumed.
  ###        current_threshold_ratio = 0.8
  ##
  ###        # Send an alert when the forecasted spend at the end of the period is greater than 200% of the budget.
  ###        forecasted_threshold_ratio = 2
  ##
  ###        # Enable this to prevent the billing account's admins to receive these alerts.
  ###        disable_default_iam_recipients = false
  ##      }
  ##
  ###      # Override this variable to name the budget GCP resource. Useful to fit naming conventions.
  ###      budget_name = "Absolute budget alert"
  ##    }
  #
  ##    # Configure a budget based on the last month's spend.
  ##    relative_amount = {
  ##
  ##      # Define budget alerts thresholds and where they will be sent.
  ##      alerts = {
  ##        notification_channels = [google_monitoring_notification_channel.email.id]
  ##
  ###        # Send an alert when the spend for this month has increased more than 20% compared to last month.
  ###        current_threshold_ratio = 1.2
  ##
  ###        # Send an alert when the month's spend is forecasted to be greater than 2 times last month's.
  ###        forecasted_threshold_ratio = 2
  ##
  ###        # Enable this to prevent the billing account's admins to receive these alerts.
  ###        disable_default_iam_recipients = false
  ##      }
  ##
  ###      # Override this variable to name the budget GCP resource. Useful to fit naming conventions.
  ###      budget_name = "Relative budget alert"
  ##    }
  #  }
}