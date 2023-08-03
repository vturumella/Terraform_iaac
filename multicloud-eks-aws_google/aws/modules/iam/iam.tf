resource "aws_iam_user" "stratos-eks-admin" {
  name = "${var.name}-admin"
  path = "/"

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_user_policy" "stratos-eks-admin-policy" {
  name = "${var.name}-policy"
  user = aws_iam_user.stratos-eks-admin.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:**",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_access_key" "stratos-eks-admin" {
  user = aws_iam_user.stratos-eks-admin.name
}
output "secret" {
  value = aws_iam_access_key.stratos-eks-admin.encrypted_secret
}

resource "aws_iam_role" "stratos-eks-admin-role" {
  name = "${var.name}-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_role_policy" "stratos" {
  name = "${var.name}-policy"
  role = aws_iam_role.stratos-eks-admin-role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_policy" "stratos-policy" {
  name        = "${var.name}-policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "stratos-eks-policy-attach" {
  role       = aws_iam_role.stratos-eks-admin-role.name
  policy_arn = aws_iam_policy.stratos-policy.arn
}
output "iam_role_policy" {
  value = aws_iam_role_policy.stratos.name
}
output "iam_role" {
  value = aws_iam_role.stratos-eks-admin-role.name
}
