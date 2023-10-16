# Overview
This is Terraform used to deploy an EKS cluster and bootstrap Flux. It creates the following
- AWS VPC
- Internet Gateway
- NAT Gateway (with EIP)
- 2x public subnets (configured as EKS ELB subnets) and 2x private subnets
- Routing for the above with public subnets going via IGW and private going via NAT Gateway
- VPC Endpoint for EKS
- EKS Cluster with managed node group and EBS CSI Driver Addon
- IAM polices and roles for
  - VPC CNI Driver
  - AWS LB Controller
  - External DNS
  - EBS CSI Driver
  - TF Controller
  - S3 Bucket for remote state storage by TF Controller
  - DynamoDB for TF Remote State Locking

The Terraform also adds the following
- Deploy key for Flux to the specified Git Repo
- Flux Bootstrap

# If forking or using the repo
- **The IAM policy for TF Controller uses ec2* on actions. You may want to further lock this down**
- I think I've moved all the vars you have to change into the tfvars. Hopefully I haven't missed any
- Make sure you're aware of how much this costs etc
- You'll be prompted for a GitHub PAT to allow it to create the deploy key