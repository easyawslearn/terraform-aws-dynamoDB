data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["application-autoscaling.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "auto_scale_role" {
  name               = "${var.app_name}-autoscaling-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

data "aws_iam_policy_document" "autoscaler" {
  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:UpdateTable",
    ]

    resources = ["${aws_dynamodb_table.default.arn}"]

    effect = "Allow"
  }
}

resource "aws_iam_role_policy" "autoscaler" {
  name   = "${var.app_name}-autoscaler-dynamodb"
  role   = "${aws_iam_role.auto_scale_role.id}"
  policy = "${data.aws_iam_policy_document.autoscaler.json}"
}

data "aws_iam_policy_document" "autoscaler_cloudwatch" {
  statement {
    actions = [
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DeleteAlarms",
    ]

    resources = ["${aws_dynamodb_table.default.arn}"]

    effect = "Allow"
  }
}

resource "aws_iam_role_policy" "autoscaler_cloudwatch" {
  name   = "${var.app_name}-autoscaler-cloudwatch"
  role   = "${aws_iam_role.auto_scale_role.id}"
  policy = "${data.aws_iam_policy_document.autoscaler_cloudwatch.json}"
}

resource "aws_appautoscaling_target" "read_target" {
  max_capacity       = "${var.autoscale_max_read_capacity}"
  min_capacity       = "${var.autoscale_min_read_capacity}"
  resource_id        = "table/${aws_dynamodb_table.default.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
  role_arn           = "${aws_iam_role.auto_scale_role.arn}"
}

resource "aws_appautoscaling_policy" "read_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.read_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.read_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.read_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = "${var.autoscale_read_target}"
  }
}

resource "aws_appautoscaling_target" "write_target" {
  max_capacity       = "${var.autoscale_max_write_capacity}"
  min_capacity       = "${var.autoscale_min_write_capacity}"
  resource_id        = "table/${aws_dynamodb_table.default.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
  role_arn           = "${aws_iam_role.auto_scale_role.arn}"
}

resource "aws_appautoscaling_policy" "write_policy" {
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.write_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.write_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.write_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = "${var.autoscale_write_target}"
  }
}
