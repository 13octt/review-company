pipeline {
    agent any

    // tools {
    //     jdk 'jdk17'
    //     nodejs 'node18'
    // }

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

        stage('DEPLOY TO K8S') {
            steps {
                withKubeConfig([credentialsId: 'k8s-config', serverUrl: 'https://kubernetes.docker.internal:6443']) {
                    sh 'kubectl version'
                    sh 'kubectl apply -f k8s/'
                    sh 'kubectl get all'
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
