resource "aws_instance" "log-server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  #下で作成するSSM用のprofileをアタッチ
  iam_instance_profile = aws_iam_instance_profile.log-server-role-profile.name

  tags = {
    Name = "log-server-ec2"
  }
}

#assume roleを作成して、EC2に使えるように設定
resource "aws_iam_role" "log-server-assume-role" {
  name = "log-server-assume-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

#SSMManagedInstanceCoreポリシーをロールにアタッチすることでSSMを使えるように
resource "aws_iam_role_policy_attachment" "log-server-assume-role-attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.log-server-assume-role.name
}

#EC2にロールをアタッチするためにロールをprofileにアタッチする
resource "aws_iam_instance_profile" "log-server-role-profile" {
  name = "log-check-instance-profile"
  role = aws_iam_role.log-server-assume-role.name
}
