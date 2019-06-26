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

In providers tf file:
```
#Extra Providers for Config and other Multi-Region configurations
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

provider "aws" {
  alias  = "us-west-1"
  region = "us-west-1"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
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