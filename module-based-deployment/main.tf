

provider "helm" {
  kubernetes {
     config_path = "~/.kube/config"
  }
}

module "sample-resource" {
  source = "./cert-manager-module"
}