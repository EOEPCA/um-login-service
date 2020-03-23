provider "kubernetes" {
  # When no host is specified this provider reads ~./kube/config
}

module "template-svce" {
  source = "../global/login"
}
