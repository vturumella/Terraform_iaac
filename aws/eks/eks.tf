/* Create EKS cluster. Kubernetes clusters managed by Amazon EKS 
IAM Role: Create Role with the needed permissions that Amazon EKS 
IAM Policy: Attach the trusted Policy (AmazonEKSClusterPolicy) which will allow Amazo */

resource "aws_eks_cluster" "eks_cluster_test" {
  name     = "eks_cluster_test"
  role_arn = aws_iam_role.eks_cluster_admin.arn

  vpc_config {
    /* vpc_id                 = aws_vpc.eks_vpc.id */
  /* security_group_ids = aws_security_group.eks_cluster_sg.id,aws_security_group.eks_cluster_n */
    subnet_ids             = flatten([aws_subnet.public_subnet[*].id])
    endpoint_public_access = true
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.Node_AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy
  ]
}

output "endpoint" {
  value = aws_eks_cluster.eks_cluster_test.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks_cluster_test.certificate_authority[0].data
}
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_cluster_admin" {
  name               = "eks-cluster-admin"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_iam_role" "eks_cluster_node" {
  name               = "eks-cluster-node"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_admin.name
}
resource "aws_iam_role_policy_attachment" "Node_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_admin.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_cluster_node.name
}
resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       =  aws_iam_role.eks_cluster_node.name
 
}
resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       =  aws_iam_role.eks_cluster_node.name
 
}


resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks_cluster"
  description = "security group for eks clusterc"
  vpc_id      = aws_vpc.eks_vpc.id

    tags = {
    Name = "eks cluster sg"
  }
}

  resource "aws_security_group_rule" "eks_inbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  
  security_group_id = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_nodesg.id
}

  resource "aws_security_group_rule" "eks_outbound" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  
  security_group_id = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_nodesg.id
}

resource "aws_security_group" "eks_nodesg" {
  name        = "eks_nodes"
  description = "security group for eks clusterc"
  vpc_id      = aws_vpc.eks_vpc.id

    tags = {
    Name = "eks worker nodes sg"
  }
}

  resource "aws_security_group_rule" "nodes_inbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"

  security_group_id = aws_security_group.eks_nodesg.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id
}

  resource "aws_security_group_rule" "nodes_outbound" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  
  security_group_id = aws_security_group.eks_nodesg.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id
}








