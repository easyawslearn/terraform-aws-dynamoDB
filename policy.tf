
// dynamodb table Read Policy
data "aws_iam_policy_document" "readpolicy" {
  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:ListTables",
      "dynamodb:Query",
      "dynamodb:Scan",
    ]

    resources = ["arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/tf-${var.app_name}"]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "readpolicy" {
  name   = "${var.app_name}-${var.region}-DynamoDb-Read-Policy"
  policy = "${data.aws_iam_policy_document.readpolicy.json}"
}

// dynamodb table Write Policy
data "aws_iam_policy_document" "writepolicy" {
  statement {
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:ListTables",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem",
      "dynamodb:UpdateTable",
    ]

    resources = ["arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/tf-${var.app_name}"]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "writepolicy" {
  name   = "${var.app_name}-${var.region}-DynamoDb-Write-Policy"
  policy = "${data.aws_iam_policy_document.writepolicy.json}"
}
