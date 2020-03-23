resource "kubernetes_pod" "gluu" {
  metadata {
    name = "gluu-pod"
    namespace = "deployment"
  }

  spec {
    container {
      image = "eoepca/um-common-gluu:latest"
      name  = "gluu"

      env {
        name  = "environment"
        value = "test"
      }
      #TODO: liveness_probe
    }
  }

  depends_on = [
    kubernetes_namespace.deployment
  ]

}


resource "kubernetes_pod" "login-engine" {
  metadata {
    name = "login-pod"
    namespace = "deployment"
  }

  spec {
    container {
      image = "eoepca/um-login-engine:latest"
      name  = "login"

      env {
        name  = "environment"
        value = "test"
      }
      #TODO: liveness_probe
    }
  }

  depends_on = [
    kubernetes_namespace.deployment,
  ]

}