provider "aws" {
  region = "us-east-1"  # Change to your region
}

# ---------------------------
# VPC + Subnets
# ---------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.0"

  name = "flask-vpc"
  cidr = "10.0.0.0/16"

  azs  = ["us-east-1a", "us-east-1b"]

  public_subnets  = ["10.0.1.0/24","10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24","10.0.12.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

# ---------------------------
# EKS Cluster + Node Group
# ---------------------------
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.0.0"

  cluster_name    = "flask-hello-cluster"
  cluster_version = "1.28"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets

  manage_aws_auth = true

  node_groups = {
    flask_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
    }
  }
}

# ---------------------------
# Outputs
# ---------------------------
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "cluster_name" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_kubeconfig_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "node_role_arn" {
  value = module.eks.node_groups["flask_nodes"].iam_role_arn
}
