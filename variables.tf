variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "quotas" {
  description = "Defines quotas and quotas alerts for the project"
  type = object({
    bigquery_quota_tb_per_day_total    = optional(number, 10)
    bigquery_quota_tb_per_day_per_user = optional(number, 10)

    alerts = optional(object({
      notification_channels                              = set(string)
      bigquery_quota_tb_per_day_total_threshold_ratio    = optional(number)
      bigquery_quota_tb_per_day_per_user_threshold_ratio = optional(number)
    }))
  })

  default = {}
}

variable "budgets" {
  description = "Defines budgets and budget alerts for the project"
  type = object({
    billing_account_id = string

    absolute_amount = optional(object({
      amount = number
      alerts = object({
        notification_channels          = set(string)
        pubsub_topic                   = optional(string)
        current_threshold_ratio        = optional(number)
        forecasted_threshold_ratio     = optional(number)
        disable_default_iam_recipients = optional(bool, false)
      })
      budget_name = optional(string, "Absolute budget alert")
    }))

    relative_amount = optional(object({
      alerts = object({
        notification_channels          = set(string)
        pubsub_topic                   = optional(string)
        current_threshold_ratio        = optional(number)
        forecasted_threshold_ratio     = optional(number)
        disable_default_iam_recipients = optional(bool, false)
      })
      budget_name = optional(string, "Relative budget alert")
    }))
  })

  default = {
    billing_account_id = null
  }

  validation {
    condition     = var.budgets.billing_account_id == null || (var.budgets.relative_amount != null || var.budgets.absolute_amount != null)
    error_message = "At least one of 'relative_amount' or 'absolute_amount' must be specified."
  }

  validation {
    condition     = var.budgets.relative_amount == null || (try(var.budgets.relative_amount.alerts.current_threshold_ratio != null, false) || try(var.budgets.relative_amount.alerts.forecasted_threshold_ratio != null, false))
    error_message = "At least one of 'relative_amount.alerts.current_threshold_ratio' or 'relative_amount.alerts.forecasted_threshold_ratio' must be specified."
  }

  validation {
    condition     = var.budgets.absolute_amount == null || (try(var.budgets.absolute_amount.alerts.current_threshold_ratio != null, false) || try(var.budgets.absolute_amount.alerts.forecasted_threshold_ratio != null, false))
    error_message = "At least one of 'absolute_amount.alerts.current_threshold_ratio' or 'absolute_amount.alerts.forecasted_threshold_ratio' must be specified."
  }
}