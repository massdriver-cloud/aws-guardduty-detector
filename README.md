[![Massdriver][logo]][website]

# aws-guardduty-detector

[![Release][release_shield]][release_url]
[![Contributors][contributors_shield]][contributors_url]
[![Forks][forks_shield]][forks_url]
[![Stargazers][stars_shield]][stars_url]
[![Issues][issues_shield]][issues_url]
[![MIT License][license_shield]][license_url]


Deploys an Amazon GuardDuty Detector to an AWS region as a threat detection service that continuously monitors your AWS accounts and workloads for malicious activity and sends emails about security findings for visibility and remediation.


---

## Design

For detailed information, check out our [Operator Guide](operator.md) for this bundle.

## Usage

Our bundles aren't intended to be used locally, outside of testing. Instead, our bundles are designed to be configured, connected, deployed and monitored in the [Massdriver][website] platform.

### What are Bundles?

Bundles are the basic building blocks of infrastructure, applications, and architectures in [Massdriver][website]. Read more [here](https://docs.massdriver.cloud/concepts/bundles).

## Bundle

### Params

Form input parameters for configuring a bundle for deployment.

<details>
<summary>View</summary>

<!-- PARAMS:START -->
## Properties

- **`detector`** *(object)*
  - **`region`** *(string)*: AWS Region to provision in.

    Examples:
    ```json
    "us-west-2"
    ```

- **`features`** *(object)*: GuardDuty monitors [foundational features](https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_data-sources.html) by default. Select any additional features you would like GuardDuty to monitor.
  - **`ebs_malware`** *(boolean)*: Enable scanning of [EBS volumes for malware](https://docs.aws.amazon.com/guardduty/latest/ug/features-malware-protection.html). Default: `False`.
  - **`eks_audit`** *(boolean)*: Enable monitoring of [EKS audit logs](https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-eks-audit-log-monitoring.html) to detect suspicious activity in your EKS clusters. Default: `False`.
  - **`eks_runtime`** *(boolean)*: Enable monitoring of [EKS runtimes](https://docs.aws.amazon.com/guardduty/latest/ug/guardduty-eks-runtime-monitoring.html) to detect suspicious activity in EKS workloads. Default: `False`.
  - **`lambda_network`** *(boolean)*: Enable monitoring of [AWS lambda invocations](https://docs.aws.amazon.com/guardduty/latest/ug/feature-in-gdu-lambda-protection.html). Default: `False`.
  - **`rds_login`** *(boolean)*: Enable monitoring [successful and unsuccessful login attempts to RDS databases](https://docs.aws.amazon.com/guardduty/latest/ug/features-rds-protection.html). Default: `False`.
  - **`s3_data`** *(boolean)*: Enable monitoring of [S3 get/put/list/delete events](https://docs.aws.amazon.com/guardduty/latest/ug/features-s3-protection.html). Default: `False`.
- **`monitoring`** *(object)*
  - **`mode`** *(string)*: Enable and customize CloudWatch metric alarms. Default: `AUTOMATED`.
    - **One of**
      - Automated
      - Custom
      - Disabled
- **`notifications`** *(object)*
  - **`email`** *(string)*: Specify email to be notified at in case of findings.
  - **`frequency`** *(string)*: Select the frequency to export events to EventHub for notifications. Default: `SIX_HOURS`.
    - **One of**
      - 15 Minutes
      - 1 Hour
      - 6 Hours
  - **`severity`** *(object)*: Select the [severity levels](https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_findings.html#guardduty_findings-severity) of GuardDuty findings to be notified about.
    - **`high`** *(boolean)*: A High severity level indicates that the resource in question is compromised and is actively being used for unauthorized purposes. Default: `True`.
    - **`low`** *(boolean)*: A low severity level indicates attempted suspicious activity that did not compromise your network. Default: `False`.
    - **`medium`** *(boolean)*: A Medium severity level indicates suspicious activity that deviates from normally observed behavior and, depending on your use case, may be indicative of a resource compromise. Default: `True`.
<!-- PARAMS:END -->

</details>

### Connections

Connections from other bundles that this bundle depends on.

<details>
<summary>View</summary>

<!-- CONNECTIONS:START -->
## Properties

- **`aws_authentication`** *(object)*: . Cannot contain additional properties.
  - **`data`** *(object)*
    - **`arn`** *(string)*: Amazon Resource Name.

      Examples:
      ```json
      "arn:aws:rds::ACCOUNT_NUMBER:db/prod"
      ```

      ```json
      "arn:aws:ec2::ACCOUNT_NUMBER:vpc/vpc-foo"
      ```

    - **`external_id`** *(string)*: An external ID is a piece of data that can be passed to the AssumeRole API of the Security Token Service (STS). You can then use the external ID in the condition element in a role's trust policy, allowing the role to be assumed only when a certain value is present in the external ID.
  - **`specs`** *(object)*
    - **`aws`** *(object)*: .
      - **`region`** *(string)*: AWS Region to provision in.

        Examples:
        ```json
        "us-west-2"
        ```

<!-- CONNECTIONS:END -->

</details>

### Artifacts

Resources created by this bundle that can be connected to other bundles.

<details>
<summary>View</summary>

<!-- ARTIFACTS:START -->
## Properties

<!-- ARTIFACTS:END -->

</details>

## Contributing

<!-- CONTRIBUTING:START -->

### Bug Reports & Feature Requests

Did we miss something? Please [submit an issue](https://github.com/massdriver-cloud/aws-guardduty-detector/issues) to report any bugs or request additional features.

### Developing

**Note**: Massdriver bundles are intended to be tightly use-case scoped, intention-based, reusable pieces of IaC for use in the [Massdriver][website] platform. For this reason, major feature additions that broaden the scope of an existing bundle are likely to be rejected by the community.

Still want to get involved? First check out our [contribution guidelines](https://docs.massdriver.cloud/bundles/contributing).

### Fix or Fork

If your use-case isn't covered by this bundle, you can still get involved! Massdriver is designed to be an extensible platform. Fork this bundle, or [create your own bundle from scratch](https://docs.massdriver.cloud/bundles/development)!

<!-- CONTRIBUTING:END -->

## Connect

<!-- CONNECT:START -->

Questions? Concerns? Adulations? We'd love to hear from you!

Please connect with us!

[![Email][email_shield]][email_url]
[![GitHub][github_shield]][github_url]
[![LinkedIn][linkedin_shield]][linkedin_url]
[![Twitter][twitter_shield]][twitter_url]
[![YouTube][youtube_shield]][youtube_url]
[![Reddit][reddit_shield]][reddit_url]

<!-- markdownlint-disable -->

[logo]: https://raw.githubusercontent.com/massdriver-cloud/docs/main/static/img/logo-with-logotype-horizontal-400x110.svg
[docs]: https://docs.massdriver.cloud/?utm_source=github&utm_medium=readme&utm_campaign=aws-guardduty-detector&utm_content=docs
[website]: https://www.massdriver.cloud/?utm_source=github&utm_medium=readme&utm_campaign=aws-guardduty-detector&utm_content=website
[github]: https://github.com/massdriver-cloud?utm_source=github&utm_medium=readme&utm_campaign=aws-guardduty-detector&utm_content=github
[slack]: https://massdriverworkspace.slack.com/?utm_source=github&utm_medium=readme&utm_campaign=aws-guardduty-detector&utm_content=slack
[linkedin]: https://www.linkedin.com/company/massdriver/?utm_source=github&utm_medium=readme&utm_campaign=aws-guardduty-detector&utm_content=linkedin



[contributors_shield]: https://img.shields.io/github/contributors/massdriver-cloud/aws-guardduty-detector.svg?style=for-the-badge
[contributors_url]: https://github.com/massdriver-cloud/aws-guardduty-detector/graphs/contributors
[forks_shield]: https://img.shields.io/github/forks/massdriver-cloud/aws-guardduty-detector.svg?style=for-the-badge
[forks_url]: https://github.com/massdriver-cloud/aws-guardduty-detector/network/members
[stars_shield]: https://img.shields.io/github/stars/massdriver-cloud/aws-guardduty-detector.svg?style=for-the-badge
[stars_url]: https://github.com/massdriver-cloud/aws-guardduty-detector/stargazers
[issues_shield]: https://img.shields.io/github/issues/massdriver-cloud/aws-guardduty-detector.svg?style=for-the-badge
[issues_url]: https://github.com/massdriver-cloud/aws-guardduty-detector/issues
[release_url]: https://github.com/massdriver-cloud/aws-guardduty-detector/releases/latest
[release_shield]: https://img.shields.io/github/release/massdriver-cloud/aws-guardduty-detector.svg?style=for-the-badge
[license_shield]: https://img.shields.io/github/license/massdriver-cloud/aws-guardduty-detector.svg?style=for-the-badge
[license_url]: https://github.com/massdriver-cloud/aws-guardduty-detector/blob/main/LICENSE


[email_url]: mailto:support@massdriver.cloud
[email_shield]: https://img.shields.io/badge/email-Massdriver-black.svg?style=for-the-badge&logo=mail.ru&color=000000
[github_url]: mailto:support@massdriver.cloud
[github_shield]: https://img.shields.io/badge/follow-Github-black.svg?style=for-the-badge&logo=github&color=181717
[linkedin_url]: https://linkedin.com/in/massdriver-cloud
[linkedin_shield]: https://img.shields.io/badge/follow-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&color=0A66C2
[twitter_url]: https://twitter.com/massdriver?utm_source=github&utm_medium=readme&utm_campaign=aws-guardduty-detector&utm_content=twitter
[twitter_shield]: https://img.shields.io/badge/follow-Twitter-black.svg?style=for-the-badge&logo=twitter&color=1DA1F2
[discourse_url]: https://community.massdriver.cloud?utm_source=github&utm_medium=readme&utm_campaign=aws-guardduty-detector&utm_content=discourse
[discourse_shield]: https://img.shields.io/badge/join-Discourse-black.svg?style=for-the-badge&logo=discourse&color=000000
[youtube_url]: https://www.youtube.com/channel/UCfj8P7MJcdlem2DJpvymtaQ
[youtube_shield]: https://img.shields.io/badge/subscribe-Youtube-black.svg?style=for-the-badge&logo=youtube&color=FF0000
[reddit_url]: https://www.reddit.com/r/massdriver
[reddit_shield]: https://img.shields.io/badge/subscribe-Reddit-black.svg?style=for-the-badge&logo=reddit&color=FF4500

<!-- markdownlint-restore -->

<!-- CONNECT:END -->
