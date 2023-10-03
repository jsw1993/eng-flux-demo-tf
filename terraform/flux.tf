resource "tls_private_key" "main" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}


resource "github_repository" "this" {
  name       = var.repository_name
  visibility = var.repository_visibility
  auto_init  = true
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = var.branch
}

resource "github_repository_deploy_key" "this" {
  title      = "staging-cluster"
  repository = github_repository.this.name
  key        = tls_private_key.main.public_key_openssh
  read_only  = false
}

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository_deploy_key.this]

  path = var.target_path
}