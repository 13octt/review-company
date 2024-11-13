pipeline {
    agent any

    stages {
        stage('Clean workspace'){
            steps{
                cleanWs()
            }
        }

        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('CONFIG K8S') {
            steps {
                withKubeConfig([
                        credentialsId: 'k8s-config', 
                        serverUrl: 'https://192.168.49.2:6443',
                        namespace: 'jenkins', 
                        contextName: 'minikube'
                ]) {
                    sh 'kubectl version'
                    sh 'kubectl get ns'
                    sh 'kubectl config use-context minikube'
                    sh 'kubectl config set-context minikube --namespace=jenkins'
                    sh 'kubectl config get-contexts'
                }
            }
        }

        stage('DEPLOY TO K8S') {
            steps {
                withKubeConfig([
                        credentialsId: 'k8s-config', 
                        serverUrl: 'https://192.168.49.2:6443',
                        namespace: 'jenkins', 
                        contextName: 'minikube',
                ]) {
                    sh 'kubectl apply -f k8s/'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
