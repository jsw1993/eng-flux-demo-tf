resource "aws_security_group" "eks_endpoint" {
  name        = "eks_endpoint"
  description = "Endpoint for EKS"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "eks_control_plane"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private-a.cidr_block, aws_subnet.private-b.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "eks" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-1.eks"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.eks_endpoint.id
  ]

  private_dns_enabled = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.16.0"

  cluster_name    = "cluster-a"
  cluster_version = "1.28"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_endpoint_public_access_cidrs = ["88.97.45.21/32", "34.240.103.169/32"]
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {}
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
  }

  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.private-a.id, aws_subnet.private-b.id]

  node_security_group_enable_recommended_rules = true
  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size      = 20
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    main = {
      min_size     = 0
      max_size     = 3
      desired_size = 1

      instance_types = ["m7a.large"]
      capacity_type  = "ON_DEMAND"
    }
  }
  tags = {
    Name = "cluster-a"
  }

}