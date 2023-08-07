output "iam_role_policy" {
  value = aws_iam_role_policy.stratos.name
}
output "iam_role" {
  value = aws_iam_role.stratos-eks-admin-role.name
}
output "ekscluster" {
  value = aws_iam_role_policy_attachment.aws-AmazonEKSClusterPolicy
}
output "endpoint" {
  value = aws_eks_cluster.stratos-eks-cluster.endpoint
}
output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.stratos-eks-cluster.certificate_authority[0].data
}
output "role_arn" {
  value = aws_iam_role.stratos-eks-admin-role.arn 
}