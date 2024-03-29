resource "tls_private_key" "main" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}


resource "github_repository_deploy_key" "this" {
  title      = "staging-cluster"
  repository = var.repository_name
  key        = tls_private_key.main.public_key_openssh
  read_only  = false
}

resource "flux_bootstrap_git" "this" {
  depends_on       = [github_repository_deploy_key.this]
  components_extra = ["image-reflector-controller", "image-automation-controller"]
  path             = var.target_path
}