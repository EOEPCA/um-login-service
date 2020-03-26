resource "kubernetes_pod" "ldap" {
  metadata {
    name = "ldap"
    namespace = "deployment"
  }

  spec {
    container {
      image = "eoepca/um-login-gluu-ldap:latest"
      name  = "ldap"

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
    name = "login-engine"
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