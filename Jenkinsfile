pipeline {
    agent any

    environment {
        IMAGE = "thirumoorthyk/flask-hello:latest"
    }

    stages {

        stage('Checkout') {
            steps {
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
                withEnv(["KUBECONFIG=/var/lib/jenkins/.kube/config"]) {
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
