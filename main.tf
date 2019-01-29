provider "aws" {
  region = "${var.region}"
}

data "aws_caller_identity" "current" {}

locals {
  attributes = [
    {
      name = "${var.range_key}"
      type = "${var.range_key_type}"
    },
    {
      name = "${var.hash_key}"
      type = "${var.hash_key_type}"
    },
    "${var.dynamodb_attributes}",
  ]

  from_index = "${length(var.range_key) > 0 ? 0 : 1}"

  attributes_final = "${slice(local.attributes, local.from_index, length(local.attributes))}"
}

resource "aws_dynamodb_table" "default" {
  name           = "${var.app_name}"
  read_capacity  = "${var.autoscale_min_read_capacity}"
  write_capacity = "${var.autoscale_min_write_capacity}"
  hash_key       = "${var.hash_key}"
  range_key      = "${var.range_key}"

  server_side_encryption {
    enabled = "${var.enable_encryption}"
  }

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute              = ["${local.attributes_final}"]

  ttl {
    attribute_name = "${var.ttl_attribute}"
    enabled        = "${var.ttl_status}"
  }

  tags {
    Name = "${var.Tag}"
  }
}
