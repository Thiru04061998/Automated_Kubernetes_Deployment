provider "aws" {
  region = "us-east-1"
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
# EKS Cluster + Node Group (updated for module v20)
# ---------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.0.0"

  cluster_name    = "flask-hello-cluster"
  cluster_version = "1.28"

  vpc_id               = module.vpc.vpc_id
  private_subnets      = module.vpc.private_subnets
  public_subnets       = module.vpc.public_subnets
  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true

  # Node groups (must use this format for module v20+)
  node_groups = {
    flask_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
    }
  }
}
