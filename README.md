<!-- BEGIN_TF_DOCS -->
<p align="center">                                                                                                                                            
                                                                                
  <img src="https://github.com/StratusGrid/terraform-readme-template/blob/main/header/stratusgrid-logo-smaller.jpg?raw=true" />
  <p align="center">                                                           
    <a href="https://stratusgrid.com/book-a-consultation">Contact Us</a> |                  
    <a href="https://stratusgrid.com/cloud-cost-optimization-dashboard">Stratusphere FinOps</a> |
    <a href="https://stratusgrid.com">StratusGrid Home</a> |
    <a href="https://stratusgrid.com/blog">Blog</a>
  </p>                    
</p>

 # terraform-aws-config-recorder

 GitHub: [StratusGrid/terraform-aws-config-recorder](https://github.com/StratusGrid/terraform-aws-config-recorder)

 This module configures config recorder for an AWS account.

 ## Examples

 ```hcl
 ### Basic Usage

# Configures config recorder and SNS Topic for an AWS account's region. Requires that you already have a bucket configured for it.
# Valid Recording Frequency Options can be found here: https://docs.aws.amazon.com/config/latest/APIReference/API_ConfigSnapshotDeliveryProperties.html#API_ConfigSnapshotDeliveryProperties_Contents

# Module Instantiation
module "aws_config_recorder" {
  source = "StratusGrid/config-recorder/aws"
  version = "1.0.1"
  log_bucket_id = "${module.s3_bucket_logging.bucket_id}"
  include_global_resource_types = true
}
 ```
 
 ```hcl
 ### Multi-Regional Usage
# For this, Recorder will be configured in multiple regions by passing in providers blocks.

# Example of multiple additional aliased providers to be stored in providers.tf file:
provider "aws" {
  allowed_account_ids = "${var.account_numbers}"
  region              = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  token      = "${var.token}"
}

# Extra Providers for Config and other Multi-Region configurations like AWS Config
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  token      = "${var.token}"
  allowed_account_ids = "${var.account_numbers}"
}

provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
  allowed_account_ids = "${var.account_numbers}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  token      = "${var.token}"
}

provider "aws" {
  alias  = "us-west-1"
  region = "us-west-1"
  allowed_account_ids = "${var.account_numbers}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  token      = "${var.token}"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
  allowed_account_ids = "${var.account_numbers}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  token      = "${var.token}"
}

## Module Instantiation
module "aws_config_recorder_us_east_1" {
  source = "StratusGrid/config-recorder/aws"
  version = "1.0.1"
  log_bucket_id = "${module.s3_bucket_logging.bucket_id}"
  include_global_resource_types = true #only include global resource on one region to prevent duplicate recording of events
  providers = {
    aws = "aws.us-east-1"
  }
}

module "aws_config_recorder_us_east_2" {
  source = "StratusGrid/config-recorder/aws"
  version = "1.0.1"
  log_bucket_id = "${module.s3_bucket_logging.bucket_id}"
  providers = {
    aws = "aws.us-east-2"
  }
}

module "aws_config_recorder_us_west_1" {
  source = "StratusGrid/config-recorder/aws"
  version = "1.0.1"
  log_bucket_id = "${module.s3_bucket_logging.bucket_id}"
  providers = {
    aws = "aws.us-west-1"
  }
}

module "aws_config_recorder_us_west_2" {
  source = "StratusGrid/config-recorder/aws"
  version = "1.0.1"
  log_bucket_id = "${module.s3_bucket_logging.bucket_id}"
  providers = {
    aws = "aws.us-west-2"
  }
}
 ```
 ---

 ## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= v1.6.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.57.0 |

 ## Resources

| Name | Type |
|------|------|
| [aws_config_aggregate_authorization.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_aggregate_authorization) | resource |
| [aws_config_configuration_aggregator.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_aggregator) | resource |
| [aws_config_configuration_recorder.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder) | resource |
| [aws_config_configuration_recorder_status.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder_status) | resource |
| [aws_config_delivery_channel.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_delivery_channel) | resource |
| [aws_iam_role.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_sns_topic.aws_config_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

 ## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_central_resource_collector_account"></a> [central\_resource\_collector\_account](#input\_central\_resource\_collector\_account) | The account ID of a central account that will aggregate AWS Config from other accounts | `string` | `null` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Flag to indicate whether an IAM Role should be created to grant the proper permissions for AWS Config | `bool` | `false` | no |
| <a name="input_create_sns_topic"></a> [create\_sns\_topic](#input\_create\_sns\_topic) | Flag to indicate whether an SNS topic should be created for notifications<br>If you want to send findings to a new SNS topic, set this to true and provide a valid configuration for subscribers<br>If you are using this module to set multiple accounts and regions, only enable the SNS topic in the aggregator account and region. | `bool` | `true` | no |
| <a name="input_global_resource_collector_region"></a> [global\_resource\_collector\_region](#input\_global\_resource\_collector\_region) | The region that collects AWS Config data | `string` | `null` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | The ARN for an IAM Role AWS Config uses to make read or write requests to the delivery channel and to describe the<br>AWS resources associated with the account. This is only used if create\_iam\_role is false.<br><br>If you want to use an existing IAM Role, set the value of this to the ARN of the existing topic and set<br>create\_iam\_role to false.<br><br>See the AWS Docs for further information:<br>http://docs.aws.amazon.com/config/latest/developerguide/iamrole-permissions.html | `string` | `null` | no |
| <a name="input_include_global_resource_types"></a> [include\_global\_resource\_types](#input\_include\_global\_resource\_types) | True/False to add global resources to config. Default is false | `string` | `false` | no |
| <a name="input_input_tags"></a> [input\_tags](#input\_input\_tags) | Map of tags to apply to resources | `map(any)` | <pre>{<br>  "Developer": "StratusGrid",<br>  "Provisioner": "Terraform"<br>}</pre> | no |
| <a name="input_is_global_recorder_region_and_account"></a> [is\_global\_recorder\_region\_and\_account](#input\_is\_global\_recorder\_region\_and\_account) | Flag to indicate whether this is the aggregator account and region | `bool` | `false` | no |
| <a name="input_log_bucket_id"></a> [log\_bucket\_id](#input\_log\_bucket\_id) | ID of bucket to log config change snapshots to | `string` | n/a | yes |
| <a name="input_recording_mode"></a> [recording\_mode](#input\_recording\_mode) | The mode for AWS Config to record configuration changes. <br><br>recording\_frequency:<br>  The frequency with which AWS Config records configuration changes (service defaults to CONTINUOUS).<br>  - CONTINUOUS<br>  - DAILY<br><br>  You can also override the recording frequency for specific resource types.<br>recording\_mode\_override:<br>  description:<br>    A description for the override.<br>  resource\_types:<br>    A list of resource types for which AWS Config records configuration changes. For example, AWS::EC2::Instance.<br>    Refer to: https://docs.aws.amazon.com/config/latest/APIReference/API_RecordingModeOverride.html<br>  recording\_frequency:<br>    The frequency with which AWS Config records configuration changes for the specified resource types.<br>    - CONTINUOUS<br>    - DAILY<br><br>/*<br>recording\_mode = {<br>  recording\_frequency = "DAILY"<br>  recording\_mode\_override = {<br>    description         = "Override for specific resource types"<br>    resource\_types      = ["AWS::EC2::Instance"]<br>    recording\_frequency = "CONTINUOUS"<br>  }<br>}<br>*/ | <pre>object({<br>    recording_frequency = string<br>    recording_mode_override = optional(object({<br>      description         = string<br>      resource_types      = list(string)<br>      recording_frequency = string<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_s3_key_prefix"></a> [s3\_key\_prefix](#input\_s3\_key\_prefix) | The prefix for AWS Config objects stored in the the S3 bucket. If this variable is set to null, the default, no<br>prefix will be used.<br><br>Examples:<br><br>with prefix:    {S3\_BUCKET NAME}:/{S3\_KEY\_PREFIX}/AWSLogs/{ACCOUNT\_ID}/Config/*.<br>without prefix: {S3\_BUCKET NAME}:/AWSLogs/{ACCOUNT\_ID}/Config/*. | `string` | `null` | no |
| <a name="input_snapshot_delivery_frequency"></a> [snapshot\_delivery\_frequency](#input\_snapshot\_delivery\_frequency) | Frequency which AWS Config snapshots the configuration | `string` | `"Three_Hours"` | no |
| <a name="input_sns_kms_key_id"></a> [sns\_kms\_key\_id](#input\_sns\_kms\_key\_id) | KMS key id for encrypting cloudtrail config recorder stream sns topic. If left empty uses SNS default AWS managed key. | `string` | `""` | no |
| <a name="input_source_collector_accounts"></a> [source\_collector\_accounts](#input\_source\_collector\_accounts) | The account IDs of other accounts that will send their AWS Configuration to this account | `set(string)` | `null` | no |
| <a name="input_source_collector_all_regions"></a> [source\_collector\_all\_regions](#input\_source\_collector\_all\_regions) | Flag to indicate whether all regions are included for the source collector | `bool` | `false` | no |
| <a name="input_source_collector_regions"></a> [source\_collector\_regions](#input\_source\_collector\_regions) | A list of regions for the source collector to use | `list(string)` | `[]` | no |
| <a name="input_subscribers"></a> [subscribers](#input\_subscribers) | A map of subscription configurations for SNS topics<br><br>For more information, see:<br>https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#argument-reference<br><br>protocol:<br>  The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially<br>  supported, see link) (email is an option but is unsupported in terraform, see link).<br>endpoint:<br>  The endpoint to send data to, the contents will vary with the protocol. (see link for more information)<br>endpoint\_auto\_confirms (Optional):<br>  Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty. Default is<br>  false<br>raw\_message\_delivery (Optional):<br>  Boolean indicating whether or not to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property). Default is false. | `map(any)` | `{}` | no |

 ## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_config_configuration_recorder_id"></a> [aws\_config\_configuration\_recorder\_id](#output\_aws\_config\_configuration\_recorder\_id) | ID of configuration recorder |
| <a name="output_aws_iam_role_config"></a> [aws\_iam\_role\_config](#output\_aws\_iam\_role\_config) | aws\_iam\_role for config |
| <a name="output_sns_encryption_kms_key_id"></a> [sns\_encryption\_kms\_key\_id](#output\_sns\_encryption\_kms\_key\_id) | Id of key used to encrypt sns topic |

 ---

 Note, manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c .config/.terraform-docs.yml`
<!-- END_TF_DOCS -->