# terraform-google-finops

This Terraform module allows you to configure and deploy:
- BigQuery quotas and quotas alerts.
- Project budgets and budgets alerts.

## Usage

### Minimal BQ quotas
```hcl
resource "google_monitoring_notification_channel" "basic" {
  display_name = "Test Notification Channel"
  type         = "email"
  labels = {
    email_address = "fake_email@blahblah.com"
  }
  force_delete = false
}

module "finops" {
  source = "./modules/finops"

  quotas = {
    bigquery_quota_tb_per_day_total    = 10  # 10 TiB Per day limit for the project
    bigquery_quota_tb_per_day_per_user = 1  # 1 TiB Per day per user limit
  }
}
```

### BQ quotas with alerts
```hcl
resource "google_monitoring_notification_channel" "basic" {
  display_name = "Test Notification Channel"
  type         = "email"
  labels = {
    email_address = "fake_email@blahblah.com"
  }
  force_delete = false
}

module "finops" {
  source = "./modules/finops"

  quotas = {
    bigquery_quota_tb_per_day_total    = 10  # 10 TiB Per day limit for the project
    bigquery_quota_tb_per_day_per_user = 1  # 1 TiB Per day per user limit

    alerts = {
      notification_channels = [google_monitoring_notification_channel.basic.id]

      # Send an alert when 80% of `bigquery_quota_tb_per_day_total` is reached
      bigquery_quota_tb_per_day_total_threshold_ratio = 0.8

      # Send an alert when 50% of `bigquery_quota_tb_per_day_per_user` is reached
      bigquery_quota_tb_per_day_per_user_threshold_ratio = 0.5
    }
  }
}
```

### BQ budgets with alerts

⚠️ This requires the principals (you and/or a service account) executing this code to be `roles/billing.costsManager` on the billing account used.
```hcl
resource "google_monitoring_notification_channel" "basic" {
  display_name = "Test Notification Channel"
  type         = "email"
  labels = {
    email_address = "fake_email@blahblah.com"
  }
  force_delete = false
}

module "finops" {
  source = "./modules/finops"

  budgets = {
    billing_account_id = "ABCDEF-ABCDEF-ABCDEF"

    # Configure a $200 USD budget for the project with alerts at 80% actual consumption and 200% forecasted consumption.
    absolute_amount = {
      amount = 200
      alerts = {
        notification_channels          = [google_monitoring_notification_channel.basic.id]

        # Send an alert when 80% of the month's budget has been consumed.
        current_threshold_ratio        = 0.8

        # Send an alert when the forecasted spend at the end of the period is greater than 200% of the budget.
        forecasted_threshold_ratio     = 2
      }
    }

    # Configure a budget based on the last month's spend.
    relative_amount = {
      alerts = {
        notification_channels          = [google_monitoring_notification_channel.basic.id]

        # Send an alert when the spend for this month has increased more than 20% compared to last month.
        current_threshold_ratio        = 1.2
      }
    }
  }
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_service_usage_consumer_quota_override.bigquery_query_total](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_service_usage_consumer_quota_override) | resource |
| [google-beta_google_service_usage_consumer_quota_override.bigquery_query_user](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_service_usage_consumer_quota_override) | resource |
| [google_billing_budget.absolute_amount_budget](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/billing_budget) | resource |
| [google_billing_budget.relative_amount_budget](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/billing_budget) | resource |
| [google_monitoring_alert_policy.bigquery_query_total_quota_alert](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_alert_policy.bigquery_query_user_quota_alert](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |
| [google_project_service.billingbudgets](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_budgets"></a> [budgets](#input\_budgets) | Defines budgets and budget alerts for the project | <pre>object({<br>    billing_account_id = string<br><br>    relative_amount = optional(object({<br>      alerts = object({<br>        notification_channels          = set(string)<br>        disable_default_iam_recipients = optional(bool, false)<br>        current_threshold_ratio        = optional(number, null)<br>        forecasted_threshold_ratio     = optional(number, null)<br>      })<br>      budget_name = optional(string, "Relative budget alert")<br>    }))<br><br>    absolute_amount = optional(object({<br>      amount = number<br>      alerts = object({<br>        notification_channels          = set(string)<br>        disable_default_iam_recipients = optional(bool, false)<br>        current_threshold_ratio        = optional(number, null)<br>        forecasted_threshold_ratio     = optional(number, null)<br>      })<br>      budget_name = optional(string, "Absolute budget alert")<br>    }))<br>  })</pre> | <pre>{<br>  "billing_account_id": null<br>}</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID | `string` | n/a | yes |
| <a name="input_quotas"></a> [quotas](#input\_quotas) | Defines quotas and quotas alerts for the project | <pre>object({<br>    bigquery_quota_tb_per_day_total    = optional(number, 10)<br>    bigquery_quota_tb_per_day_per_user = optional(number, 10)<br><br>    alerts = optional(object({<br>      notification_channels                              = set(string)<br>      bigquery_quota_tb_per_day_total_threshold_ratio    = optional(number)<br>      bigquery_quota_tb_per_day_per_user_threshold_ratio = optional(number)<br>    }))<br>  })</pre> | `{}` | no |

## Outputs

No outputs.
