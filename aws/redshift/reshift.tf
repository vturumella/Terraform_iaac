resource "aws_redshift_cluster" "redshift_cluster" {
  depends_on         = [
    aws_vpc.rs_vpc, aws_redshift_subnet_group.rs_sub_grp, aws_iam_role.redhift_admin,
    aws_iam_role_policy_attachment.node_AmazonRedshiftAllCommandsFullAccess,
    aws_iam_role_policy_attachment.node_AmazonRedshiftFullAccess
    
        
    ]
  cluster_identifier = "tf-redshift-cluster"
  database_name      = "mydb"
  master_username    = "exampleuser"
  master_password    = "Mustbe8characters"
  node_type          = "dc2.large"
  cluster_type       = "single-node"

  iam_roles                 = [aws_iam_role.redhift_admin.arn]
  cluster_subnet_group_name = aws_redshift_subnet_group.rs_sub_grp.id
  skip_final_snapshot       = true

  
}

/* Creating the IAM Role and Policies for Redshift */
resource "aws_iam_role_policy" "redshift_policy" {
  name = "redshiftt_policy"
  role = aws_iam_role.redhift_admin.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
          "iam:CreateRole",
          "iam:createPolicy"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "redhift_admin" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_AmazonRedshiftAllCommandsFullAccess" {
  role       = aws_iam_role.redhift_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftAllCommandsFullAccess "
}
resource "aws_iam_role_policy_attachment" "node_AmazonRedshiftFullAccess" {
  role       = aws_iam_role.redhift_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess"
}