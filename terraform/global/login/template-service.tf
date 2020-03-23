resource "kubernetes_pod" "gluu" {
  metadata {
    name = "terraform-example"
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
}


resource "kubernetes_pod" "login-engine" {
  metadata {
    name = "terraform-example"
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
}