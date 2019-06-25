resource "aws_iam_role" "config" {
  name = "${var.name_prefix}-aws-config-role${var.name_suffix}"
  tags = "${var.input_tags}"

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
  role       = "${aws_iam_role.config.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_config_configuration_recorder" "config" {
  name     = "${var.name_prefix}-aws-config-recorder${var.name_suffix}"
  role_arn = "${aws_iam_role.config.arn}"

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "config" {
  name           = "${var.name_prefix}-aws-config-delivery${var.name_suffix}"
  s3_bucket_name = "${var.log_bucket_id}"
  s3_key_prefix  = "aws-config/${var.name_prefix}-aws-config${var.name_suffix}"
  sns_topic_arn  = "${var.sns_topic_arn}"

  snapshot_delivery_properties {
    delivery_frequency = "${var.snapshot_delivery_frequency}"
  }

  depends_on = ["aws_config_configuration_recorder.config"]
}

resource "aws_config_configuration_recorder_status" "config" {
  name       = "${aws_config_configuration_recorder.config.name}"
  is_enabled = true

  depends_on = ["aws_config_delivery_channel.config"]
}