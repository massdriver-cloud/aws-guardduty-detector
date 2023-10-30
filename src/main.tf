resource "aws_guardduty_detector" "main" {
  enable                       = true
  finding_publishing_frequency = var.notifications.frequency
}

resource "aws_guardduty_detector_feature" "s3_data" {
  detector_id = aws_guardduty_detector.main.id
  name        = "S3_DATA_EVENTS"
  status      = var.features.s3_data ? "ENABLED" : "DISABLED"
}

resource "aws_guardduty_detector_feature" "eks_audit" {
  detector_id = aws_guardduty_detector.main.id
  name        = "EKS_AUDIT_LOGS"
  status      = var.features.eks_audit ? "ENABLED" : "DISABLED"
}

resource "aws_guardduty_detector_feature" "ebs_malware" {
  detector_id = aws_guardduty_detector.main.id
  name        = "EBS_MALWARE_PROTECTION"
  status      = var.features.ebs_malware ? "ENABLED" : "DISABLED"
}

resource "aws_guardduty_detector_feature" "rds_login" {
  detector_id = aws_guardduty_detector.main.id
  name        = "RDS_LOGIN_EVENTS"
  status      = var.features.rds_login ? "ENABLED" : "DISABLED"
}

resource "aws_guardduty_detector_feature" "eks_runtime" {
  detector_id = aws_guardduty_detector.main.id
  name        = "EKS_RUNTIME_MONITORING"
  status      = var.features.eks_runtime ? "ENABLED" : "DISABLED"

  additional_configuration {
    name   = "EKS_ADDON_MANAGEMENT"
    status = var.features.eks_runtime ? "ENABLED" : "DISABLED"
  }
}

resource "aws_guardduty_detector_feature" "lambda_network" {
  detector_id = aws_guardduty_detector.main.id
  name        = "LAMBDA_NETWORK_LOGS"
  status      = var.features.lambda_network ? "ENABLED" : "DISABLED"
}


resource "aws_sns_topic" "findings" {
  name                        = var.md_metadata.name_prefix
  display_name                = var.md_metadata.name_prefix
  kms_master_key_id           = "alias/aws/sns"
  fifo_topic                  = false
  content_based_deduplication = false
}

# module "sns_topic" {

#   source  = "cloudposse/sns-topic/aws"
#   version = "0.20.1"
#   count   = local.create_sns_topic ? 1 : 0

#   subscribers     = var.subscribers
#   sqs_dlq_enabled = false

#   attributes = concat(module.this.attributes, ["guardduty"])
#   context    = module.this.context
# }

# module "findings_label" {
#   source  = "cloudposse/label/null"
#   version = "0.25.0"

#   attributes = concat(module.this.attributes, ["guardduty", "findings"])
#   context    = module.this.context
# }

resource "aws_sns_topic_subscription" "findings" {
  topic_arn = aws_sns_topic.findings.arn
  protocol  = "email"
  endpoint  = var.notifications.email
}

resource "aws_sns_topic_policy" "findings" {
  arn    = aws_sns_topic.findings.arn
  policy = data.aws_iam_policy_document.findings.json
}

data "aws_iam_policy_document" "findings" {
  policy_id = "GuardDutyPublishToSNS"
  statement {
    sid = ""
    actions = [
      "sns:Publish"
    ]
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
    resources = [aws_sns_topic.findings.arn]
    effect    = "Allow"
  }
}

locals {
  low_severity = [
    1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9,
    2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9,
    3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9,
  ]
  medium_severity = [
    4.0, 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.8, 4.9,
    5.0, 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7, 5.8, 5.9,
    6.0, 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 6.7, 6.8, 6.9,
  ]
  high_severity = [
    7.0, 7.1, 7.2, 7.3, 7.4, 7.5, 7.6, 7.7, 7.8, 7.9,
    8.0, 8.1, 8.2, 8.3, 8.4, 8.5, 8.6, 8.7, 8.8, 8.9,
  ]
  severity = concat(
    var.notifications.severity.low ? local.low_severity : [],
    var.notifications.severity.medium ? local.medium_severity : [],
    var.notifications.severity.high ? local.high_severity : []
  )
}

resource "aws_cloudwatch_event_rule" "findings" {
  name        = var.md_metadata.name_prefix
  description = "GuardDuty Findings"

  event_pattern = jsonencode(
    {
      "source" : [
        "aws.guardduty"
      ],
      "detail-type" : [
        "GuardDuty Finding"
      ]
      "detail" : {
        "severity" : local.severity
      }
    }
  )
}

resource "aws_cloudwatch_event_target" "findings" {
  rule  = aws_cloudwatch_event_rule.findings.name
  arn   = aws_sns_topic.findings.arn
}
