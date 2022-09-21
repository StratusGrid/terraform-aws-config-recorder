output "aws_config_configuration_recorder_id" {
  description = "ID of configuration recorder"
  value       = aws_config_configuration_recorder.config.id
}