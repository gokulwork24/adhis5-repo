output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "web_app_service_url" {
  value = kubernetes_service.web_app.status[0].load_balancer[0].ingress[0].hostname
}
