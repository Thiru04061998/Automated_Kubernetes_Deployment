provider "aws" {
  region = "us-east-1"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "flask-hello-cluster"
  cluster_version = "1.27"
  subnets         = ["subnet-xxxx", "subnet-yyyy"] # Your existing VPC subnets
  vpc_id          = "vpc-xxxx"
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
