terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
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

provider "aws" {
  region  = "eu-west-1"
  profile = "save-it"
  default_tags {
    tags = {
      Environment = "eng-flux-demo"
    }
  }
}

provider "flux" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
  git = {
    url  = "ssh://git@github.com/jsw1993/eng-flux-demo.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.main.private_key_pem
    }
  }
}

provider "kubectl" {}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "github" {
  owner = var.github_owner
  token = var.github_token
}

resource "aws_vpc" "main" {
  cidr_block = "172.16.68.0/22"

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

resource "aws_internet_gateway_attachment" "main" {
  internet_gateway_id = aws_internet_gateway.main.id
  vpc_id              = aws_vpc.main.id
}

resource "aws_eip" "ngw-a" {
  domain   = "vpc"
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