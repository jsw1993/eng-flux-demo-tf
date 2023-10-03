module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.31.2"

  cluster_name    = "cluster-a"
  cluster_version = "1.28"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_endpoint_public_access_cidrs = ["88.97.45.21/32"]

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {}
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.private-a.id, aws_subnet.private-b.id]


  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size      = 20
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    main = {
      min_size     = 0
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Name = "cluster-a"
  }
}