provider "kubernetes" {
  # When no host is specified this provider reads ~./kube/config
}

module "login" {
  source = "../global/login"
}
