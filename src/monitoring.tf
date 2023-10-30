locals {
  automated_alarms = {
    failed_notifications = {
      period    = 300
      threshold = 1
      statistic = "Sum"
    }
    guardduty_findings = {
      period    = 300
      threshold = 1
      statistic = "Sum"
    }
  }
  alarms_map = {
    "AUTOMATED" = local.automated_alarms
    "DISABLED"  = {}
    "CUSTOM"    = lookup(var.monitoring, "alarms", {})
  }

  alarms = lookup(local.alarms_map, var.monitoring.mode, {})
}

module "alarm_channel" {
  source      = "github.com/massdriver-cloud/terraform-modules//aws/alarm-channel?ref=d7b440e"
  md_metadata = var.md_metadata
}

module "failed_notifications_alarm" {
  count = lookup(local.alarms, "failed_notifications", null) == null ? 0 : 1

  source        = "github.com/massdriver-cloud/terraform-modules//aws/cloudwatch-alarm?ref=d7b440e"
  sns_topic_arn = module.alarm_channel.arn
  depends_on = [
    aws_sns_topic.findings
  ]

  md_metadata         = var.md_metadata
  display_name        = "Failed Notifications"
  message             = "SNS Topic ${var.md_metadata.name_prefix}: has failed to deliver messages"
  alarm_name          = "${var.md_metadata.name_prefix}-numberOfNotificationsFailed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "NumberOfNotificationsFailed"
  namespace           = "AWS/SNS"
  statistic           = local.alarms.failed_notifications.statistic
  period              = local.alarms.failed_notifications.period
  threshold           = local.alarms.failed_notifications.threshold

  dimensions = {
    TopicName = var.md_metadata.name_prefix
  }
}

module "guardduty_findings_alarm" {
  count = lookup(local.alarms, "guardduty_findings", null) == null ? 0 : 1

  source        = "github.com/massdriver-cloud/terraform-modules//aws/cloudwatch-alarm?ref=d7b440e"
  sns_topic_arn = module.alarm_channel.arn
  depends_on = [
    aws_sns_topic.findings
  ]

  md_metadata         = var.md_metadata
  display_name        = "GuardDuty Findings"
  message             = "GuardDuty has published notifications to SNS topic ${var.md_metadata.name_prefix}"
  alarm_name          = "${var.md_metadata.name_prefix}-numberOfMessagesPublished"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "NumberOfMessagesPublished"
  namespace           = "AWS/SNS"
  statistic           = local.alarms.guardduty_findings.statistic
  period              = local.alarms.guardduty_findings.period
  threshold           = local.alarms.guardduty_findings.threshold

  dimensions = {
    TopicName = var.md_metadata.name_prefix
  }
}