terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.10.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = ">= 0.0.13"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 4.5.2"
    }

  }
}

provider "flux" {
  kubernetes = {
    config_path = "~/.kube/config"
    config_context = "arn:aws:eks:eu-west-1:656627883778:cluster/cluster-a/default"
  }
  git = {
    url = var.git_url
    ssh = {
      username    = "git"
      private_key = tls_private_key.main.private_key_pem
    }
  }
}

provider "github" {
  owner = var.github_owner
  token = var.github_token
}


provider "aws" {
  region  = var.region
  profile = var.aws_profile
  default_tags {
    tags = {
      Environment = "eng-flux-demo"
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "172.16.68.0/22"
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_eip" "ngw-a" {
  domain = "vpc"
  tags = {
    Name = "ngw-a-eip"
  }
}

resource "aws_nat_gateway" "ngw-a" {
  allocation_id = aws_eip.ngw-a.id
  subnet_id     = aws_subnet.public-a.id

  tags = {
    Name = "ngw-a"
  }
}