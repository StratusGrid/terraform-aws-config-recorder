data "aws_region" "current" {}

data "aws_kms_key" "sns_default" {
  key_id = "alias/aws/sns"
}

locals {
  sns_kms_key_id = var.sns_kms_key_id != "" ? var.sns_kms_key_id : data.aws_kms_key.sns_default.id
}

resource "aws_iam_role" "config" {
  name = "aws-config-role-${data.aws_region.current.name}"
  tags = local.common_tags

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "config" {
  role       = aws_iam_role.config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_config_configuration_recorder" "config" {
  name     = "aws-config-recorder"
  role_arn = aws_iam_role.config.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = var.include_global_resource_types
  }
}

resource "aws_config_delivery_channel" "config" {
  name           = "aws-config-delivery-channel"
  s3_bucket_name = var.log_bucket_id
  s3_key_prefix  = "config"
  sns_topic_arn  = aws_sns_topic.aws_config_stream.arn

  snapshot_delivery_properties {
    delivery_frequency = var.snapshot_delivery_frequency
  }

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_configuration_recorder_status" "config" {
  name       = aws_config_configuration_recorder.config.name
  is_enabled = true

  depends_on = [aws_config_delivery_channel.config]
}

#tfsec:ignore:aws-sns-enable-topic-encryption -- Ignores error on Turning on SNS Topic encryption.
resource "aws_sns_topic" "aws_config_stream" {
  name              = "aws-config-stream-${data.aws_region.current.name}"
  kms_master_key_id = local.sns_kms_key_id
  tags              = local.common_tags
}

data "aws_iam_policy_document" "config_sns" {
  statement {
    actions = [
      "sns:Publish",
    ]
    principals {
      identifiers = [
        "config.amazonaws.com",
      ]
      type = "Service"
    }
    resources = [
      aws_sns_topic.aws_config_stream.arn,
    ]
    sid = "ConfigSNSPolicy"
  }
  statement {
    actions = [
      "sns:Publish",
    ]
    condition {
      test = "Bool"
      values = [
        "false",
      ]
      variable = "aws:SecureTransport"
    }
    effect = "Deny"
    principals {
      identifiers = [
        "*",
      ]
      type = "AWS"
    }
    resources = [
      aws_sns_topic.aws_config_stream.arn,
    ]
    sid = "DenyUnsecuredTransport"
  }
}

resource "aws_sns_topic_policy" "config" {
  arn    = aws_sns_topic.aws_config_stream.arn
  policy = data.aws_iam_policy_document.config_sns.json
}