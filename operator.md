## AWS GuardDuty

Amazon GuardDuty is a threat detection service that continuously monitors your AWS accounts and workloads for malicious activity and anomalous behavior. With GuardDuty, you can monitor for unauthorized and unexpected behaviors in your AWS workloads and accounts, and integrate with other AWS services to remediate threats automatically.

### Design Decisions

1. **Enabling Core Features**: The solution automatically enables critical GuardDuty features such as S3 Data Events, EKS Audit Logs, EBS Malware Protection, RDS Login Events, and Lambda Network Logs based on user configuration.
2. **Notifications**: Uses Amazon SNS to send notifications about GuardDuty findings. Users can specify an email to receive alerts.
3. **CloudWatch Integration**: Integrates with CloudWatch for monitoring and alerting, automatically creating CloudWatch event rules and SNS topics to handle findings.
4. **Automatic Alarms**: Configures automatic CloudWatch alarms for failed SNS notifications and GuardDuty findings using user-defined thresholds.
5. **Modular Approach**: Utilizes separate modules for alarms and notifications to keep provisioning organized and maintainable.

### Runbook

#### GuardDuty Findings Not Showing Up in CloudWatch

If GuardDuty findings are not appearing in CloudWatch as expected, it's essential to verify the CloudWatch Event Rule configuration.

1. **Check CloudWatch Event Rule**

List all the CloudWatch Event Rules:

```sh
aws events list-rules
```

Describe the specific rule to ensure it matches the expected pattern:

```sh
aws events describe-rule --name <your_rule_name>
```

Ensure the event pattern includes:
- Source: `"aws.guardduty"`
- Detail-Type: `"GuardDuty Finding"`
- Appropriate severity levels in the detail section.

#### SNS Topic Not Receiving Notifications

If the SNS topic is not receiving notifications from GuardDuty, verify the SNS topic configuration.

1. **Check SNS Topics and Subscriptions**

List your SNS topics to ensure they exist:

```sh
aws sns list-topics
```

List subscriptions to make sure your endpoints are attached to the correct topics:

```sh
aws sns list-subscriptions-by-topic --topic-arn <your_topic_arn>
```

2. **Subscribe an Email to the SNS Topic**

If the email subscription is missing, manually subscribe:

```sh
aws sns subscribe --topic-arn <your_topic_arn> --protocol email --notification-endpoint <your_email@example.com>
```

3. **Verify SNS Topic Policy**

Ensure that the SNS topic policy allows `sns:Publish` from `cloudwatch.amazonaws.com`.

```sh
aws sns get-topic-attributes --topic-arn <your_topic_arn>
```

Look for the `Policy` attribute and verify the permissions.

#### Viewing GuardDuty Findings in the AWS Management Console

Sometimes the findings are present but not visible via the CLI or API.

1. **Check GuardDuty Findings in the Console**

Go to the AWS Management Console:
- Navigate to GuardDuty.
- Check the "Findings" section to view detailed issues flagged by GuardDuty.

This manual inspection can help verify that findings are being generated even if not properly routed to SNS or CloudWatch.

