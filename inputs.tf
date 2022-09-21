### Commented out name_prefix and name_suffix since there can only be one config stream and you don't see the name anywhere
### When you have names and the name changes, it requires manual intervention.

# variable "name_prefix" {
#   description = "String to prefix on object names"
#   type = "string"
# }

# variable "name_suffix" {
#   description = "String to append to object names. This is optional, so start with dash if using"
#   type = "string"
#   default = ""
# }

variable "input_tags" {
  description = "Map of tags to apply to resources"
  type        = map
  default = {
    Developer   = "StratusGrid"
    Provisioner = "Terraform"
  }
}

variable "log_bucket_id" {
  description = "ID of bucket to log config change snapshots to"
  type        = string
}

variable "snapshot_delivery_frequency" {
  description = "Frequency which AWS Config snapshots the configuration"
  type        = string
  default     = "Three_Hours"
}

variable "include_global_resource_types" {
  description = "True/False to add global resources to config. Default is false"
  type        = string
  default     = false
}
