resource "aws_iam_role_policy_attachment" "aws-AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.stratos-fargate-admin.name
}
resource "aws_iam_role_policy_attachment" "stratos-eks-policy-attach" {
  role       = aws_iam_role.stratos-eks-admin-role.name
  policy_arn = aws_iam_policy.stratos-policy.arn
}
resource "aws_iam_role_policy_attachment" "aws-AmazonEKSClusterPolicy" {
  role       = aws_iam_role.stratos-eks-admin-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role_policy_attachment" "aws-AmazonEKSVPCResourceController" {
  role       = aws_iam_role.stratos-eks-admin-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}
resource "aws_iam_role_policy_attachment" "aws-AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.stratos-eks-node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "aws-AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.stratos-eks-node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
resource "aws_iam_role_policy_attachment" "aws-AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.stratos-eks-node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
