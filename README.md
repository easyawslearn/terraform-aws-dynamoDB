
Terraform Module to provision a DynamoDB table with auto-scaling.


# Terraform AWS DynamoDB

## Overview

Terraform Module to provision a DynamoDB table with auto-scaling.


## Variables

**source**: (String) the git repository of the central ecs service module with "git::https//" protocol

**region**: (String) the region to deploy to

**app_name**: (String) the name of DynamoDB table

**Tag**: (String) Tag for the dynamoDb table

**hash_key**: (String) The attribute to use as the hash key,A simple primary key of table

**range_key**: (String) The attribute to use as the range key

## Outputs

**table_id**: id of the DynamoDb table

**table_arn**: table arn of DynamoDb table

**table_name**: table name of DynamoDb table

**readpolicy**: read policy name created with DynamoDb table

**writepolicy**: Write policy name created with DynamoDb table

##Example

#### main.tf

```
module "AWS_Dynamodb_table" {
  source                       = "git::ssh://git@git.cloud.sophos:7999/platform/central-ecs-dynamo-db.git?ref=develop"
  region                       = "eu-central-1"
  app_name                     = "my-table-name}"
  Tag                          = "Name of the table"
  hash_key                     = "hash_key_name"
  range_key                    = "range_key_name"
}

```



