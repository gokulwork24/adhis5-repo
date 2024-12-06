output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.eks.token
}
