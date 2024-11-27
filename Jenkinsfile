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

        stage('DEPLOY SERVICES TO K3S') {
            steps {
                withKubeConfig([
                        credentialsId: 'k3s', 
                        serverUrl: 'https://52.4.165.255:6443',
                        namespace: 'jenkins', 
                        contextName: 'default',
                ]) {
                    sh 'k3s kubectl apply -f k8s/rabbit-deployment.yaml'
                    sh 'k3s kubectl apply -f k8s/postgresql-deployment.yaml'
                }
            }
        }

        stage('DEPLOY APPLICATIONS TO K3S') {
            steps {
                withKubeConfig([
                        credentialsId: 'k3s', 
                        serverUrl: 'https://52.4.165.255:6443',
                        namespace: 'jenkins', 
                        contextName: 'default',
                ]) {
                    echo 'Checking version, namespace, context...'
                    sh 'k3s kubectl version'
                    sh 'k3s kubectl get ns'
                    sh 'k3s kubectl config get-contexts'

                    echo 'Creating database'
                    sh '''
                        k3s kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "SELECT 1 FROM pg_database WHERE datname = 'job';" | grep -q 1 || kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "CREATE DATABASE job;"
                        k3s kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "SELECT 1 FROM pg_database WHERE datname = 'review';" | grep -q 1 || kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "CREATE DATABASE review;"
                        k3s kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "SELECT 1 FROM pg_database WHERE datname = 'company';" | grep -q 1 || kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "CREATE DATABASE company;"
                    '''

                    echo 'Deploy to k8s'
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
