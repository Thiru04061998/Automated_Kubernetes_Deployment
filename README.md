Automated Kubernetes Deployment using Terraform & Jenkins

#Overview

This repository demonstrates an end-to-end DevOps workflow for deploying a simple web application to a managed Kubernetes cluster (Amazon EKS) using industry-standard DevOps tools and practices.

The solution automates:

Infrastructure provisioning using Terraform

Application containerization using Docker

Application deployment using Kubernetes

Continuous Integration and Continuous Deployment using Jenkins

Any commit to the repository triggers a Jenkins pipeline that builds, pushes, and deploys the application automatically.

Architecture
Developer Commit → GitHub Repository
                  ↓
              Jenkins Pipeline
                  ↓
          Docker Image Build
                  ↓
      Push to Container Registry
                  ↓
          kubectl Deployment
                  ↓
           Amazon EKS Cluster
                  ↓
         Public Load Balancer

Tech Stack

Cloud Provider: AWS

Kubernetes: Amazon EKS

Infrastructure as Code: Terraform

CI/CD Tool: Jenkins

Containerization: Docker

Container Registry: Docker Hub

Web Server: Nginx (Hello World)

Repository Structure
.
├── app/                     # Application source code
├── Dockerfile               # Docker image definition
├── terraform/               # Terraform IaC for EKS
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── provider.tf
├── k8s/                     # Kubernetes manifests
│   ├── deployment.yaml
│   └── service.yaml
├── Jenkinsfile              # Jenkins pipeline definition
└── README.md

Execution Steps
Step 1: Provision EKS Cluster using Terraform

Navigate to the Terraform directory and run:

cd terraform
terraform init
terraform plan
terraform apply


This provisions:

Amazon EKS cluster

Worker node group

Networking and IAM roles

Step 2: Configure kubectl Access

After the cluster is created:

aws eks update-kubeconfig --region ap-south-1 --name hello-eks-cluster


Verify:

kubectl get nodes

Step 3: Jenkins Pipeline Execution

Once infrastructure is ready:

Jenkins is configured with:

Docker

kubectl

AWS CLI

Required credentials are stored securely in Jenkins Credentials Manager

Any commit to the repository triggers the Jenkins pipeline

The pipeline performs:

Docker image build

Push image to container registry

Apply Kubernetes manifests using kubectl

Jenkins Pipeline Overview

The Jenkins pipeline is defined in a Jenkinsfile and includes stages for:

Source code checkout

Docker image build

Docker image push

Kubernetes deployment to EKS

The pipeline ensures fully automated deployments with no manual intervention.

Live Application URL

The application is publicly accessible at:

🔗 http://a2fd528b4b7244a11b412fed131b88d7-548785846.ap-south-1.elb.amazonaws.com/

## Screenshots
Screenshots demonstrating pipeline execution and deployment
are available in the `screenshots/` directory.
