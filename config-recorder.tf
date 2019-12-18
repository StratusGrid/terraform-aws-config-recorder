data "aws_region" "current" {}

resource "aws_iam_role" "config" {
  name = "aws-config-role-${data.aws_region.current.name}"
  tags = var.input_tags

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
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
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

resource "aws_sns_topic" "aws_config_stream" {
  name = "aws-config-stream-${data.aws_region.current.name}"
  tags = var.input_tags
}
