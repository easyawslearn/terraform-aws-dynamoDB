variable "region" {
  description = "region name where you want to deploy"
  default = "eu-central-1"
}

variable "app_name" {
  description = "Dynamodb table name (space is not allowed)"
}

variable "Tag" {
  description = "An owner tag to tag resources with."
}

variable "enable_encryption" {
  description = "Whether to enable Server Side encryption,Default is false"
  default     = "true"
}

variable "hash_key" {
  description = "The attribute to use as the hash key"
  type        = "string"
}

variable "range_key" {
  description = "The attribute to use as the range key"
  type        = "string"
}

variable "ttl_attribute" {
  description = "The name of the table attribute to store the TTL timestamp in"
  type        = "string"
  default     = ""
}

variable "ttl_status" {
  description = "ttl status"
  default     = "false"
}

variable "autoscale_write_target" {
  description = "Dynamodb default Autoscale write target value"
  default     = 10
}

variable "autoscale_read_target" {
  description = "Dynamodb default Autoscale read target value"
  default     = 10
}

variable "autoscale_min_read_capacity" {
  description = "The minimum read capacity unit"
  default     = 10
}

variable "autoscale_max_read_capacity" {
  description = "The Maximum read capacity unit"
  default     = 100
}

variable "autoscale_min_write_capacity" {
  description = "The minimum write capacity unit"
  default     = 5
}

variable "autoscale_max_write_capacity" {
  description = "The Maximum write capacity unit"
  default     = 200
}
