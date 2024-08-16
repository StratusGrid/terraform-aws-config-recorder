variable "central_resource_collector_account" {
  description = "The account ID of a central account that will aggregate AWS Config from other accounts"
  type        = string
  default     = null
}
variable "create_iam_role" {
  description = "Flag to indicate whether an IAM Role should be created to grant the proper permissions for AWS Config"
  type        = bool
  default     = false
}

variable "create_sns_topic" {
  description = <<-DOC
    Flag to indicate whether an SNS topic should be created for notifications
    If you want to send findings to a new SNS topic, set this to true and provide a valid configuration for subscribers
    If you are using this module to set multiple accounts and regions, only enable the SNS topic in the aggregator account and region.
  DOC
  type        = bool
  default     = true
}

variable "iam_role_arn" {
  description = <<-DOC
    The ARN for an IAM Role AWS Config uses to make read or write requests to the delivery channel and to describe the
    AWS resources associated with the account. This is only used if create_iam_role is false.

    If you want to use an existing IAM Role, set the value of this to the ARN of the existing topic and set
    create_iam_role to false.

    See the AWS Docs for further information:
    http://docs.aws.amazon.com/config/latest/developerguide/iamrole-permissions.html
  DOC
  default     = null
  type        = string
}

variable "include_global_resource_types" {
  description = "True/False to add global resources to config. Default is false"
  type        = string
  default     = false
}

variable "input_tags" {
  description = "Map of tags to apply to resources"
  type        = map(any)
  default = {
    Developer   = "StratusGrid"
    Provisioner = "Terraform"
  }
}

variable "is_global_recorder_region_and_account" {
  description = "Flag to indicate whether this is the aggregator account and region"
  type        = bool
  default     = false
}

variable "log_bucket_id" {
  description = "ID of bucket to log config change snapshots to"
  type        = string
}
variable "global_resource_collector_region" {
  description = "The region that collects AWS Config data"
  type        = string
  default     = null
}
variable "recording_mode" {
  description = <<-DOC
    The mode for AWS Config to record configuration changes. 

    recording_frequency:
      The frequency with which AWS Config records configuration changes (service defaults to CONTINUOUS).
      - CONTINUOUS
      - DAILY

      You can also override the recording frequency for specific resource types.
    recording_mode_override:
      description:
        A description for the override.
      resource_types:
        A list of resource types for which AWS Config records configuration changes. For example, AWS::EC2::Instance.
        Refer to: https://docs.aws.amazon.com/config/latest/APIReference/API_RecordingModeOverride.html
      recording_frequency:
        The frequency with which AWS Config records configuration changes for the specified resource types.
        - CONTINUOUS
        - DAILY

    /*
    recording_mode = {
      recording_frequency = "DAILY"
      recording_mode_override = {
        description         = "Override for specific resource types"
        resource_types      = ["AWS::EC2::Instance"]
        recording_frequency = "CONTINUOUS"
      }
    }
    */
  DOC
  type = object({
    recording_frequency = string
    recording_mode_override = optional(object({
      description         = string
      resource_types      = list(string)
      recording_frequency = string
    }))
  })
  default = null
}

variable "s3_key_prefix" {
  type        = string
  description = <<-DOC
    The prefix for AWS Config objects stored in the the S3 bucket. If this variable is set to null, the default, no
    prefix will be used.

    Examples:

    with prefix:    {S3_BUCKET NAME}:/{S3_KEY_PREFIX}/AWSLogs/{ACCOUNT_ID}/Config/*.
    without prefix: {S3_BUCKET NAME}:/AWSLogs/{ACCOUNT_ID}/Config/*.
  DOC
  default     = null
}

variable "snapshot_delivery_frequency" {
  description = "Frequency which AWS Config snapshots the configuration"
  type        = string
  default     = "Three_Hours"
}

variable "sns_kms_key_id" {
  description = "KMS key id for encrypting cloudtrail config recorder stream sns topic. If left empty uses SNS default AWS managed key."
  type        = string
  default     = ""
}

variable "source_collector_accounts" {
  description = "The account IDs of other accounts that will send their AWS Configuration to this account"
  type        = set(string)
  default     = null
}
variable "source_collector_all_regions" {
  description = "Flag to indicate whether all regions are included for the source collector"
  type        = bool
  default     = false
}
variable "source_collector_regions" {
  description = "A list of regions for the source collector to use"
  type        = list(string)
  default     = []
}

variable "subscribers" {
  type        = map(any)
  description = <<-DOC
    A map of subscription configurations for SNS topics

    For more information, see:
    https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#argument-reference

    protocol:
      The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially
      supported, see link) (email is an option but is unsupported in terraform, see link).
    endpoint:
      The endpoint to send data to, the contents will vary with the protocol. (see link for more information)
    endpoint_auto_confirms (Optional):
      Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty. Default is
      false
    raw_message_delivery (Optional):
      Boolean indicating whether or not to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property). Default is false.
  DOC
  default     = {}
}
