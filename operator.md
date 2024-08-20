## AWS GuardDuty

AWS GuardDuty is a managed threat detection service that continuously monitors for malicious activity and unauthorized behavior to protect your AWS accounts, workloads, and data stored in Amazon S3. GuardDuty uses integrated threat intelligence, machine learning, and anomaly detection to identify threats and generate actionable security findings.

### Design Decisions

- **Enablement**: The GuardDuty detector is enabled by default to ensure continuous monitoring.
- **Finding Publishing Frequency**: Configurable via variable (`notifications.frequency`) to determine how often findings are published.
- **Feature Toggles**: Optional features such as S3 data events, EKS audit logs, and Lambda network logs can be enabled or disabled based on your needs.
- **SNS Topic for Notifications**: An SNS topic is utilized to deliver GuardDuty findings notifications. Policies are configured to allow GuardDuty to publish to this SNS topic.
- **CloudWatch Integration**: CloudWatch event rules and targets are set up to capture GuardDuty findings and trigger alarms for critical alerts.
- **Automated Alarms**: Pre-configured alarms for failed notifications and GuardDuty findings to ensure alerting mechanisms are monitored for any delivery issues.

### Runbook

#### GuardDuty Detector is Not Enabled

Verify if the GuardDuty detector is enabled.

```sh
aws guardduty list-detectors
```

The output should list the detector IDs. If no detectors are listed, then GuardDuty is not enabled.

#### GuardDuty Findings Are Not Being Published

Check if findings are being published regularly.

```sh
aws guardduty get-findings --detector-id <detector-id>
```

This command returns the findings. If no findings are listed, ensure that the finding publishing frequency is set and that incidents are occurring.

#### SNS Notifications Are Not Being Delivered

Validate the SNS topic configuration and its subscribers.

```sh
aws sns list-subscriptions-by-topic --topic-arn <sns-topic-arn>
```

Ensure the email or other endpoint is correctly subscribed.

Check for delivery issues in CloudWatch metrics.

```sh
aws cloudwatch get-metric-statistics \
    --namespace AWS/SNS \
    --metric-name NumberOfNotificationsFailed \
    --dimensions Name=TopicName,Value=<sns-topic-name> \
    --start-time <start-time> \
    --end-time <end-time> \
    --period 300 \
    --statistics Sum
```

Ensure there are no failed notifications. If there are delivery failures, check the endpoint configuration and permissions.

#### CloudWatch Alarms Not Triggering

Verify if the CloudWatch event rule for GuardDuty findings is correctly configured.

```sh
aws events list-rules | grep GuardDuty
```

Check if the event rule is capturing the correct severity of findings.

Ensure the alarm configuration matches the expected thresholds and periods.

```sh
aws cloudwatch describe-alarms --alarm-names "<alarm-name>"
```

Review the alarm’s configuration and ensure it aligns with the detected metrics.

