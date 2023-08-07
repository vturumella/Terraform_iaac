resource "aws_iam_role" "stratos-fargate-admin" {
  name = "${var.name}-eks-fargate-profile"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}
resource "aws_iam_role" "stratos-eks-node" {
  name = "${var.name}-eks-node"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}
resource "aws_iam_user" "stratos-eks-admin" {
  name          = "${var.name}-admin"
  path          = "/"
  force_destroy = true

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
# resource "aws_rds_cluster_role_association" "stratos-pgsql-role-assoc" {
#     db_cluster_identifier = var.rds_cluster_identifier
#     feature_name           = "S3_INTEGRATION"
#     role_arn               = aws_eks_cluster.stratos-eks-cluster.arn
# }


