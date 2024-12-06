resource "aws_eks_cluster" "eks" {
  name     = var.my_eks_cluster
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator"]
}

resource "aws_iam_role" "eks_role" {
  name = "eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = { Service = "eks.amazonaws.com" }
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

/*output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.eks.token
}*/

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.name
}
