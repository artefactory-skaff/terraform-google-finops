data "google_project" "project" {
  project_id = var.project_id
}

resource "google_project_service" "billingbudgets" {
  project = data.google_project.project.project_id

  service                    = "billingbudgets.googleapis.com"
  disable_on_destroy         = false
  disable_dependent_services = false
}

resource "google_billing_budget" "relative_amount_budget" {
  count = var.budgets.billing_account_id != null && var.budgets.relative_amount != null ? 1 : 0

  billing_account = var.budgets.billing_account_id
  display_name    = var.budgets.relative_amount.budget_name

  budget_filter {
    projects = ["projects/${data.google_project.project.number}"]
  }

  amount {
    last_period_amount = true
  }

  dynamic "threshold_rules" {
    for_each = { for key, value in { CURRENT_SPEND : var.budgets.relative_amount.alerts.current_threshold_ratio, FORECASTED_SPEND : var.budgets.relative_amount.alerts.forecasted_threshold_ratio } : key => value if value != null }
    content {
      threshold_percent = threshold_rules.value
      spend_basis       = threshold_rules.key
    }
  }

  dynamic "all_updates_rule" {
    for_each = length(var.budgets.relative_amount.alerts.notification_channels) > 0 ? [1] : []
    content {
      monitoring_notification_channels = var.budgets.relative_amount.alerts.notification_channels
      pubsub_topic                     = var.budgets.relative_amount.alerts.pubsub_topic
      disable_default_iam_recipients   = var.budgets.relative_amount.alerts.disable_default_iam_recipients
    }
  }

  depends_on = [google_project_service.billingbudgets]
}

resource "google_billing_budget" "absolute_amount_budget" {
  count = var.budgets.billing_account_id != null && var.budgets.absolute_amount != null ? 1 : 0

  billing_account = var.budgets.billing_account_id
  display_name    = var.budgets.absolute_amount.budget_name

  budget_filter {
    projects = ["projects/${data.google_project.project.number}"]
  }

  amount {
    specified_amount {
      units = var.budgets.absolute_amount.amount
    }
  }

  dynamic "threshold_rules" {
    for_each = { for key, value in { CURRENT_SPEND : var.budgets.absolute_amount.alerts.current_threshold_ratio, FORECASTED_SPEND : var.budgets.absolute_amount.alerts.forecasted_threshold_ratio } : key => value if value != null }
    content {
      threshold_percent = threshold_rules.value
      spend_basis       = threshold_rules.key
    }
  }

  dynamic "all_updates_rule" {
    for_each = length(var.budgets.relative_amount.alerts.notification_channels) > 0 ? [1] : []
    content {
      monitoring_notification_channels = var.budgets.relative_amount.alerts.notification_channels
      pubsub_topic                     = var.budgets.relative_amount.alerts.pubsub_topic
      disable_default_iam_recipients   = var.budgets.relative_amount.alerts.disable_default_iam_recipients
    }
  }

  depends_on = [google_project_service.billingbudgets]
}