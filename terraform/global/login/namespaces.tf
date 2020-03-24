resource "kubernetes_namespace" "deployment" {
  metadata {
    labels = {
      mylabel = "deployment"
    }

    name = "deployment"
  }
}
