# terraform-aws-aws-config-recorder
Configures config recorder and SNS Topic for an AWS account's region. Requires that you already have a bucket configured for it.

Valid Recording Frequency Options can be found here: https://docs.aws.amazon.com/config/latest/APIReference/API_ConfigSnapshotDeliveryProperties.html#API_ConfigSnapshotDeliveryProperties_Contents

### Basic Usage:
```
module "aws_config_recorder" {
  source = "StratusGrid/config-recorder/aws"
  version = "1.0.1"
  log_bucket_id = "${module.s3_bucket_logging.bucket_id}"
  include_global_resource_types = true
}
```

### Multi-Region Usage:
For this, we will configure Recorder in multiple regions by passing in providers blocks.

Example of multiple additional aliased providers in providers tf file:
```
provider "aws" {
  allowed_account_ids = "${var.account_numbers}"
  region              = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  token      = "${var.token}"
}

#Extra Providers for Config and other Multi-Region configurations like AWS Config
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
  allowed_account_ids = "${var.account_numbers}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  token      = "${var.token}"
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

```

In config recorder tf file:
```
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