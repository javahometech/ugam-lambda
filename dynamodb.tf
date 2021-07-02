resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "UGAM_JSON_FEED"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "CUSTOMER_ID"

  attribute {
    name = "CUSTOMER_ID"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags = {
    Name        = "ugam-json-feeds"
    Environment = terraform.workspace
  }
  lifecycle {
    ignore_changes = [
      ttl,
    ]
  }
}