pipeline {
    agent any

    environment {
        IMAGE = "thirumoorthyk/flask-hello:latest"
        AWS_REGION = "ap-south-1"
        EKS_CLUSTER = "hello-eks-cluster"
    }

    stages {

        stage('Checkout') {
            steps {
                // Checkout your GitHub repo
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build Docker image from Dockerfile
                sh 'docker build -t $IMAGE .'
            }
        }

        stage('Push Docker Image') {
            steps {
                // Use Jenkins credentials to push to Docker Hub
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds', 
                    usernameVariable: 'USER', 
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                    echo $PASS | docker login -u $USER --password-stdin
                    docker push $IMAGE
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                // Use AWS IAM credentials to access EKS
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-eks-creds']]) {
                    sh '''
                    # Update kubeconfig for EKS cluster
                    aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER

                    # Apply Kubernetes manifests
                    kubectl apply -f k8s/

                    # Wait for deployment rollout
                    kubectl rollout status deployment flask-app
                    '''
                }
            }
        }

    }

    post {
        success {
            echo 'Pipeline completed successfully. Application deployed to EKS!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
