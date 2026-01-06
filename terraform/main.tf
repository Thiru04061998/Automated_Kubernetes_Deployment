terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

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
# EKS Cluster + Node Group
# ---------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.2.0"

  cluster_name    = "flask-hello-cluster"
  cluster_version = "1.28"

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets

  # Node groups using "node_groups" block supported in v20+
  node_groups = {
    flask_nodes = {
      desired_capacity = 2
      min_capacity     = 1
      max_capacity     = 3
      instance_type    = "t3.medium"
    }
  }
}
