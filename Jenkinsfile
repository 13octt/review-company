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
                        serverUrl: 'https://44.194.59.175:8443',
                        namespace: 'jenkins', 
                        contextName: 'default',
                ]) {
                    sh 'sudo k3s kubectl apply -f k8s/rabbit-deployment.yaml'
                    sh 'sudo k3s kubectl apply -f k8s/postgresql-deployment.yaml'
                }
            }
        }

        stage('DEPLOY APPLICATIONS TO K3S') {
            steps {
                withKubeConfig([
                        credentialsId: 'k3s', 
                        serverUrl: 'https://44.194.59.175:8443',
                        namespace: 'jenkins', 
                        contextName: 'default',
                ]) {
                    echo 'Checking version, namespace, context...'
                    sh 'sudo k3s kubectl version'
                    sh 'sudo k3s kubectl get ns'
                    sh 'sudo k3s ubectl config get-contexts'

                    echo 'Creating database'
                    sh '''
                        sudo k3s kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "SELECT 1 FROM pg_database WHERE datname = 'job';" | grep -q 1 || kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "CREATE DATABASE job;"
                        sudo k3s kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "SELECT 1 FROM pg_database WHERE datname = 'review';" | grep -q 1 || kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "CREATE DATABASE review;"
                        sudo k3s kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "SELECT 1 FROM pg_database WHERE datname = 'company';" | grep -q 1 || kubectl exec postgres-0 -n jenkins -- psql -U embarkx -c "CREATE DATABASE company;"
                    '''

                    echo 'Deploy to k8s'
                    sh 'sudo k3s kubectl apply -f k8s/companyms-deployment.yaml'
                    sh 'sudo k3s kubectl apply -f k8s/jobms-deployment.yaml'
                    sh 'sudo k3s kubectl apply -f k8s/reviewms-deployment.yaml'

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
