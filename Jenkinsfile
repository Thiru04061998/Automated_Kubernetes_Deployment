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
                // Checkout from GitHub repo
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE .'
            }
        }

        stage('Push Docker Image') {
            steps {
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
                // Use AWS credentials to update kubeconfig
                withAWS(credentials: 'aws-eks-creds', region: "$AWS_REGION") {
                    sh 'aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER'
                    sh 'kubectl apply -f k8s/'
                    sh 'kubectl rollout status deployment flask-app'
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
