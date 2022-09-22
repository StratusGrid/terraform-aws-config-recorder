<!-- BEGIN_TF_DOCS -->
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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.63 |

## Resources

| Name | Type |
|------|------|
| [aws_config_configuration_recorder.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder) | resource |
| [aws_config_configuration_recorder_status.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder_status) | resource |
| [aws_config_delivery_channel.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_delivery_channel) | resource |
| [aws_iam_role.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_sns_topic.aws_config_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_include_global_resource_types"></a> [include\_global\_resource\_types](#input\_include\_global\_resource\_types) | True/False to add global resources to config. Default is false | `string` | `false` | no |
| <a name="input_input_tags"></a> [input\_tags](#input\_input\_tags) | Map of tags to apply to resources | `map(any)` | <pre>{<br>  "Developer": "StratusGrid",<br>  "Provisioner": "Terraform"<br>}</pre> | no |
| <a name="input_log_bucket_id"></a> [log\_bucket\_id](#input\_log\_bucket\_id) | ID of bucket to log config change snapshots to | `string` | n/a | yes |
| <a name="input_snapshot_delivery_frequency"></a> [snapshot\_delivery\_frequency](#input\_snapshot\_delivery\_frequency) | Frequency which AWS Config snapshots the configuration | `string` | `"Three_Hours"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_config_configuration_recorder_id"></a> [aws\_config\_configuration\_recorder\_id](#output\_aws\_config\_configuration\_recorder\_id) | ID of configuration recorder |

---

Note, manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c .config/.terraform-docs.yml`
<!-- END_TF_DOCS -->