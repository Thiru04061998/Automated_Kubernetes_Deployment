pipeline {
    agent any

    environment {
        // Your Docker Hub image name
        IMAGE = "thirumoorthyk/flask-hello:latest"
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
                // Use kubeconfig secret file to deploy to Kubernetes
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh 'kubectl apply -f k8s/'
                    sh 'kubectl rollout status deployment flask-app'
                }
            }
        }

    }

    post {
        success {
            echo ' Pipeline completed successfully. Application deployed to EKS!'
        }
        failure {
            echo ' Pipeline failed. Check logs for details.'
        }
    }
}
