pipeline {
    agent any

    environment {
        KUBE_SERVER = 'https://98.85.24.58/:6443'
        KUBE_NAMESPACE = 'jenkins'
        KUBE_CONTEXT = 'default'
        KUBE_CREDENTIALS = 'k3s'
    }

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

        stage('CHECK VERSION') {
            steps {
                withKubeConfig([
                        credentialsId: KUBE_CREDENTIALS, 
                        serverUrl: KUBE_SERVER,
                        namespace: KUBE_NAMESPACE, 
                        contextName: KUBE_CONTEXT,
                ]) {
                    echo 'Checking version, namespace, context...'
                    sh 'k3s kubectl version'
                    sh 'k3s kubectl get ns'
                    sh 'k3s kubectl config get-contexts'
                }
            }
        }

        stage('DEPLOY DATABASE TO K3S') {
            steps {
                withKubeConfig([
                        credentialsId: KUBE_CREDENTIALS, 
                        serverUrl: KUBE_SERVER,
                        namespace: KUBE_NAMESPACE, 
                        contextName: KUBE_CONTEXT,
                ]) {
                    sh 'k3s kubectl apply -f k8s/postgresql-deployment.yaml'
                }
            }
        }

        stage('CREATE DATABASE FOR MICROSERVICES') {
            steps {
                withKubeConfig([
                        credentialsId: KUBE_CREDENTIALS, 
                        serverUrl: KUBE_SERVER,
                        namespace: KUBE_NAMESPACE, 
                        contextName: KUBE_CONTEXT,
                ]) {
                    echo 'Waitting postgres is running...'
                    sh 'k3s kubectl wait --for=condition=ready pod/postgres-0 -n jenkins --timeout=300s'
                    
                    echo 'Creating database...'
                    sh '''
                        k3s kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "SELECT 1 FROM pg_database WHERE datname = 'job';" | grep -q 1 || kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "CREATE DATABASE job;"
                        k3s kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "SELECT 1 FROM pg_database WHERE datname = 'review';" | grep -q 1 || kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "CREATE DATABASE review;"
                        k3s kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "SELECT 1 FROM pg_database WHERE datname = 'company';" | grep -q 1 || kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "CREATE DATABASE company;"
                    '''
                }
            }
        }

        stage('DEPLOY APPLICATIONS TO KUBERNETES') {
            steps {
                withKubeConfig([
                        credentialsId: KUBE_CREDENTIALS, 
                        serverUrl: KUBE_SERVER,
                        namespace: KUBE_NAMESPACE, 
                        contextName: KUBE_CONTEXT,
                ]) {
                    echo 'Deploy to k3s'
                    sh 'k3s kubectl apply -f k8s/companyms-deployment.yaml'
                    sh 'k3s kubectl apply -f k8s/jobms-deployment.yaml'
                    sh 'k3s kubectl apply -f k8s/reviewms-deployment.yaml'
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
