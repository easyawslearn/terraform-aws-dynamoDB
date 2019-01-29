provider "aws" {
  region = "${var.region}"
}

data "aws_caller_identity" "current" {}

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

  attribute {
    name = "${var.hash_key}"
    type = "S"
  }

  attribute {
    name = "${var.range_key}"
    type = "S"
  }

  ttl {
    attribute_name = "${var.ttl_attribute}"
    enabled        = "${var.ttl_status}"
  }

  tags {
    Name = "${var.Tag}"
  }
}
