output "aws_config_configuration_recorder_id" {
  description = "ID of configuration recorder"
  value       = aws_config_configuration_recorder.config.id
}

output "sns_encryption_kms_key_id" {
  description = "Id of key used to encrypt sns topic"
  value       = local.sns_kms_key_id
}
