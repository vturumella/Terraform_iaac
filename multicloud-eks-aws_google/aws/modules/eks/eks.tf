resource "aws_eks_cluster" "stratos-eks-cluster" {

  name     = "${var.name}-cluster"
  role_arn = aws_iam_role.stratos-eks-admin-role.arn

  vpc_config {
    subnet_ids = [var.subnet_public, var.subnet_private]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.aws-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.aws-AmazonEKSVPCResourceController

  ]
}
resource "aws_eks_fargate_profile" "stratos_eks_fargate" {
  cluster_name           = aws_eks_cluster.stratos-eks-cluster.name
  fargate_profile_name   = "${var.name}-fargate-profile"
  pod_execution_role_arn = aws_iam_role.stratos-fargate-admin.arn
  subnet_ids             = [var.subnet_private]

  selector {
    namespace = "default"
  }
}
resource "aws_eks_node_group" "stratos-eks-node-grp" {
  cluster_name    = aws_eks_cluster.stratos-eks-cluster.name
  node_group_name = "${var.name}-node-grp"
  node_role_arn   = aws_iam_role.stratos-eks-node.arn
  subnet_ids      = [var.subnet_public, var.subnet_private]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.aws-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.aws-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.aws-AmazonEC2ContainerRegistryReadOnly,
  ]
}