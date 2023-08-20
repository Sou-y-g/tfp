#VPC
resource "aws_vpc" "log-check-vpc" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "log-check-vpc"
  }
}

#Internet Gateway
#resource "aws_internet_gateway" "gw" {
#  vpc_id = aws_vpc.log-check-vpc.id
#
#  tags = {
#    Name = "log-check-vpc-gw"
#  }
#}

#Subnet
resource "aws_subnet" "log-check-sub" {
  vpc_id                  = aws_vpc.log-check-vpc.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.availability_zone
  tags = {
    Name = "log-check-sub"
  }
}

#Route_Table
resource "aws_route_table" "log-check-rt" {
  vpc_id = aws_vpc.log-check-vpc.id
}

#Route_TableとSubnetの紐付け
resource "aws_route_table_association" "log-check-rta" {
  subnet_id = aws_subnet.log-check-sub.id
  route_table_id = aws_route_table.log-check-rt.id
}

#security_group
resource "aws_security_group" "log-check-sg" {
  name        = "log-check-sg"
  vpc_id = aws_vpc.log-check-vpc.id
}

#インバウンド(HTTPS)
resource "aws_security_group_rule" "ingress-only-HTTPS" {
  security_group_id = aws_security_group.log-check-sg.id
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}

#アウトバウンド(全開放)
resource "aws_security_group_rule" "egress-all" {
  security_group_id = aws_security_group.log-check-sg.id
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

#VPC_Endpoint x3
resource "aws_vpc_endpoint" "ssm" {
  vpc_id             = aws_vpc.log-check-vpc.id
  service_name       = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.log-check-sg.id]
  subnet_ids         = [aws_subnet.log-check-sub.id]
  private_dns_enabled = true

  tags = {
    Name = "log-check-ssm-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id             = aws_vpc.log-check-vpc.id
  service_name       = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.log-check-sg.id]
  subnet_ids         = [aws_subnet.log-check-sub.id]
  private_dns_enabled = true

  tags = {
    Name = "log-check-ec2messages-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id             = aws_vpc.log-check-vpc.id
  service_name       = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.log-check-sg.id]
  subnet_ids         = [aws_subnet.log-check-sub.id]
  private_dns_enabled = true

  tags = {
    Name = "log-check-ssmmessages-vpc-endpoint"
  }
}

#VPC_Flowlogs
resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn    = aws_iam_role.log-check-iam-role.arn
  log_destination = aws_cloudwatch_log_group.log-check-watch-group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.log-check-vpc.id

  #ログの最大集約間隔を1分(テスト用)
  #max_aggregation_interval = "60"
  #ログレコード(カスタム形式)
  log_format = "$${version} $${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status}"

  tags = {
    Name = "log-check-vpc-flow-log"
  }
}

#cloudwatch ロググループ作成
resource "aws_cloudwatch_log_group" "log-check-watch-group" {
  name = "log-check-watch-group"
  retention_in_days = "1"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

#vpc flowlog用のIAM Role作成
resource "aws_iam_role" "log-check-iam-role" {
  name               = "log-check-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "log-check-watch-policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

#ポリシーアタッチ
resource "aws_iam_role_policy" "log-check-attach-policy" {
  name   = "log-check-attach-policy"
  role   = aws_iam_role.log-check-iam-role.id
  policy = data.aws_iam_policy_document.log-check-watch-policy.json
}
