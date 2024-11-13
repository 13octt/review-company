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

        stage('DEPLOY SERVICES TO K8S') {
            steps {
                withKubeConfig([
                        credentialsId: 'k8s-config', 
                        serverUrl: 'https://kubernetes.docker.internal:6443',
                        namespace: 'jenkins', 
                        contextName: 'k8s',
                ]) {
                    sh 'kubectl apply -f k8s/rabbit-deployment.yaml'
                    sh 'kubectl apply -f k8s/postgresql-deployment.yaml'
                    sh 'kubectl apply -f k8s/zipkin-deployment.yaml'

                    echo 'Creating database'

                    sh '''
                        kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "CREATE DATABASE job;"
                        kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "CREATE DATABASE review;"
                        kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "CREATE DATABASE company;"
                    '''
                }
            }
        }

        stage('DEPLOY TO K8S') {
            steps {
                withKubeConfig([
                        credentialsId: 'k8s-config', 
                        serverUrl: 'https://kubernetes.docker.internal:6443',
                        namespace: 'jenkins', 
                        contextName: 'k8s',
                ]) {
                    echo 'Checking version, namespace, context...'
                    sh 'kubectl version'
                    sh 'kubectl get ns'
                    sh 'kubectl config get-contexts'

                    echo 'Deploy to k8s'
                    sh 'kubectl apply -f k8s/companyms-deployment.yaml'
                    sh 'kubectl apply -f k8s/jobms-deployment.yaml'
                    sh 'kubectl apply -f k8s/reviewms-deployment.yaml'

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
