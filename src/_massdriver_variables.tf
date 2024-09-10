// Auto-generated variable declarations from massdriver.yaml
variable "aws_authentication" {
  type = object({
    data = object({
      arn         = string
      external_id = optional(string)
    })
    specs = object({
      aws = optional(object({
        region = optional(string)
      }))
    })
  })
}
variable "detector" {
  type = object({
    region = string
  })
}
variable "features" {
  type = object({
    ebs_malware    = bool
    eks_audit      = bool
    eks_runtime    = bool
    lambda_network = bool
    rds_login      = bool
    s3_data        = bool
  })
}
variable "md_metadata" {
  type = object({
    default_tags = object({
      managed-by  = string
      md-manifest = string
      md-package  = string
      md-project  = string
      md-target   = string
    })
    deployment = object({
      id = string
    })
    name_prefix = string
    observability = object({
      alarm_webhook_url = string
    })
    package = object({
      created_at             = string
      deployment_enqueued_at = string
      previous_status        = string
      updated_at             = string
    })
    target = object({
      contact_email = string
    })
  })
}
variable "monitoring" {
  type = object({
    mode = optional(string)
    alarms = optional(object({
      failed_notifications = object({
        period    = number
        statistic = string
        threshold = number
      })
      guardduty_findings = object({
        period    = number
        statistic = string
        threshold = number
      })
    }))
  })
}
variable "notifications" {
  type = object({
    email     = string
    frequency = string
    severity = object({
      high   = bool
      low    = bool
      medium = bool
    })
  })
}
