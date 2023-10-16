variable "github_owner" {
  type        = string
  description = "github owner"
}

variable "github_token" {
  type        = string
  description = "github token"
  sensitive   = true
}

variable "repository_name" {
  type        = string
  default     = "test-provider"
  description = "github repository name"
}

variable "repository_visibility" {
  type        = string
  default     = "private"
  description = "How visible is the github repo"
}

variable "branch" {
  type        = string
  default     = "main"
  description = "branch name"
}

variable "target_path" {
  type        = string
  default     = "staging-cluster"
  description = "flux sync target path"
}

variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "AWS Region"
}

variable "aws_profile" {
  type        = string
  default     = null
  description = "AWS Profile Name"
}

variable "eks_public_ips" {
  type        = list(string)
  default     = []
  description = "List of public IPs allowed to access EKS Cluster"
}

variable "git_url" {
  type        = string
  default     = ""
  description = "URL of git repo containing flux config"
}

variable "tf_state_s3_bucket_name" {
  type    = string
  default = "eng2023-tf-state"

}