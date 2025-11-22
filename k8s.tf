terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.38.0"
    }
  }
}


provider "kubernetes" {
  host                   = aws_eks_cluster.devopsshack.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.devopsshack.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.devopsshack.id ]
    command     = "aws"
  }
}

/*
provider "kubernetes" {
  host                   = data.aws_eks_cluster.devopsshack.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.devopsshack.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.devopsshack.token
}

data "aws_eks_cluster" "devopsshack" {
  name     = aws_eks_cluster.devopsshack.id
}

data "aws_eks_cluster_auth" "devopsshack" {
  #name = data.aws_eks_cluster.devopsshack.name
  name     = aws_eks_cluster.devopsshack.id
}

*/

resource "kubernetes_namespace_v1" "online-boutique" {
  metadata {

    name = "online-boutique"
  }
}


resource "kubernetes_role" "namespaced-viewer" {
  metadata {
    name = "namespaced-viewer"
    namespace = "online-boutique"
  }

  rule {
    api_groups     = [""]
    resources      = ["pods", "services", "secrets", "configmaps"]
    verbs          = ["get", "list", "watch", "describe"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "statefulsets", "daemonsets"]
    verbs      = ["get", "list", "watch", "describe"]
  }
}


resource "kubernetes_role_binding" "namespaced-viewer-Bind" {
  metadata {
    name      = "namespaced-viewer-Bind"
    namespace = "online-boutique"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "namespaced-viewer"
  }
  subject {
    kind      = "User"
    name      = "developer"
    api_group = "rbac.authorization.k8s.io"
  }
}


resource "kubernetes_cluster_role" "cluster-viewer" {
  metadata {
    name = "cluster-viewer"
  }

  rule {
    api_groups = [""]
    resources  = ["*"]
    verbs      = ["get", "list", "watch", "describe"]
  }
}

resource "kubernetes_cluster_role_binding" "cluster-viewer-Bind" {
  metadata {
    name = "cluster-viewer-Bind"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-viewer"
  }
  subject {
    kind      = "User"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }
}
