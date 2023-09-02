resource "aws_dynamodb_table" "db" {
  name = "${var.tag}-db"
  read_capacity = 1
  write_capacity = 1
  hash_key = "id"

  attribute {
    name = "id"
    type = "N"
  }
}

#resource "aws_dynamodb_table" "NextAuthTable" {
#  name           = "next-auth"
#  billing_mode   = "PROVISIONED"
#  read_capacity  = 20
#  write_capacity = 20
#  hash_key       = "pk"
#  range_key      = "sk"
#
#  attribute {
#    name = "pk"
#    type = "S"
#  }
#
#  attribute {
#    name = "sk"
#    type = "S"
#  }
#
#  attribute {
#    name = "GSI1PK"
#    type = "S"
#  }
#
#  attribute {
#    name = "GSI1SK"
#    type = "S"
#  }
#
#  ttl {
#    attribute_name = "expires"
#    enabled        = true
#  }
#
#  global_secondary_index {
#    name               = "GSI1"
#    hash_key           = "GSI1PK"
#    range_key          = "GSI1SK"
#    write_capacity     = 20
#    read_capacity      = 20
#    projection_type    = "ALL"
#  }
#}
#