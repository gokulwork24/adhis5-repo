terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.5.0"
    }
  }
}

/*provider "aws" {
  region = "ap-southeast-1"
}*/

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  cidr_block = "10.0.0.0/16"
}

# EKS Module
module "eks" {
  source          = "./modules/eks"
  my-eks-cluster    = "my_eks_cluster"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.subnet_ids
  desired_capacity = 2
  max_size         = 3
  min_size         = 1
}

# Kubernetes Provider
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = module.eks.cluster_token
}

# Web Application Deployment
resource "kubernetes_namespace" "web_app" {
  metadata {
    name = "web-app"
  }
}

resource "kubernetes_deployment" "web_app" {
  metadata {
    name      = "web-app-deployment"
    namespace = kubernetes_namespace.web_app.metadata[0].name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "web-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "web-app"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"
          ports {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "web_app" {
  metadata {
    name      = "web-app-service"
    namespace = kubernetes_namespace.web_app.metadata[0].name
  }
  spec {
    selector = {
      app = "web-app"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}
