pipeline {
    agent any

    tools {
        jdk 'jdk17'
        nodejs 'node18'
        maven 'maven-3.9.9'
        dockerTool 'docker'
    }

    environment {
        SCANNER_HOME        = tool 'sonar-scanner'
        SONAR_KEY_COMPANY   = 'Company-MS'
        SONAR_KEY_JOB       = 'Job-MS'
        SONAR_KEY_REVIEW    = 'Review-MS'
        SONAR_URL           = 'http://192.168.23.1:9000'
        DOCKER_REGISTRY     = 'lambaoduy1310'
        IMAGE_TAG           = 'latest'
        // IMAGE_TAG           = "v1.${BUILD_NUMBER}"  
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
                // git branch: 'main', url: 'https://github.com/13octt/review-company.git'
            }
        }

        stage('Build Company MS') {
            steps {
                dir('companyms') {
                    script {
                        sh 'chmod +x ./mvnw'
                        sh './mvnw -N io.takari:maven:wrapper || true'
                        sh './mvnw spring-boot:build-image -DskipTests -Dspring-boot.build-image.imageName=${DOCKER_REGISTRY}/companyms:${IMAGE_TAG}'
                    }
                }
            }
        }

        stage('Build Review MS') {
            steps {
                dir('reviewms') {
                    script {
                        sh 'chmod +x ./mvnw'
                        sh './mvnw -N io.takari:maven:wrapper || true'
                        sh './mvnw spring-boot:build-image -DskipTests -Dspring-boot.build-image.imageName=${DOCKER_REGISTRY}/reviewms:${IMAGE_TAG}'
                    }
                }
            }
        }

        stage('Build Job MS') {
            steps {
                dir('jobms') {
                    script {
                        sh 'chmod +x ./mvnw'
                        sh './mvnw -N io.takari:maven:wrapper || true'
                        sh './mvnw spring-boot:build-image -DskipTests -Dspring-boot.build-image.imageName=${DOCKER_REGISTRY}/jobms:${IMAGE_TAG}'
                    }
                }
            }
        }

        stage('SonarQube Analys for Company MS') {
            steps {
                dir('companyms'){
                    script {
                        withSonarQubeEnv('sonar-server') {
                            sh '${SCANNER_HOME}/bin/sonar-scanner --version'
                            sh """
                                ${SCANNER_HOME}/bin/sonar-scanner \
                                    -Dsonar.projectKey=${SONAR_KEY_COMPANY} \
                                    -Dsonar.sources=. \
                                    -Dsonar.host.url=${SONAR_URL} \
                                    -Dsonar.java.binaries=target/classes \
                            """
                        }
                    }
                }
            }
        }

        stage('SonarQube Analys for Job MS') {
            steps {
                dir('jobms'){
                    script {
                        withSonarQubeEnv('sonar-server') {
                            sh '${SCANNER_HOME}/bin/sonar-scanner --version'
                            sh """
                                ${SCANNER_HOME}/bin/sonar-scanner \
                                    -Dsonar.projectKey=${SONAR_KEY_JOB} \
                                    -Dsonar.sources=. \
                                    -Dsonar.host.url=${SONAR_URL} \
                                    -Dsonar.java.binaries=target/classes \
                            """
                        }
                    }
                }
            }
        }

        stage('SonarQube Analys for Review MS') {
            steps {
                dir('reviewms'){
                    script {
                        withSonarQubeEnv('sonar-server') {
                            sh '${SCANNER_HOME}/bin/sonar-scanner --version'
                            sh """
                                ${SCANNER_HOME}/bin/sonar-scanner \
                                    -Dsonar.projectKey=${SONAR_KEY_REVIEW} \
                                    -Dsonar.sources=. \
                                    -Dsonar.host.url=${SONAR_URL} \
                                    -Dsonar.java.binaries=target/classes \
                            """
                        }
                    }
                }
            }
        }

        stage('TRIVY FS SCAN') {
            steps {
                echo 'Scanning Files System...'
                sh "trivy fs ."
            }
        }

        stage('Push Company MS Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                        echo 'Pushing to Docker Hub...'
                        sh "docker push ${DOCKER_REGISTRY}/companyms:${IMAGE_TAG}"
                        sh "docker push ${DOCKER_REGISTRY}/jobms:${IMAGE_TAG}"
                        sh "docker push ${DOCKER_REGISTRY}/reviewms:${IMAGE_TAG}"
                    }
                }
            }
        }

        stage('TRIVY DOCKER IMAGE SCAN') {
            steps {
                echo 'Scanning docker image...'
                sh "trivy image ${DOCKER_REGISTRY}/companyms:${IMAGE_TAG}"
                sh "trivy image ${DOCKER_REGISTRY}/jobms:${IMAGE_TAG}"
                sh "trivy image ${DOCKER_REGISTRY}/reviewms:${IMAGE_TAG}"
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
        always {
            echo 'Cleaning up local Docker images...'
            sh "docker rmi ${DOCKER_REGISTRY}/companyms:${IMAGE_TAG} || true"
            sh "docker rmi ${DOCKER_REGISTRY}/jobms:${IMAGE_TAG} || true"
            sh "docker rmi ${DOCKER_REGISTRY}/reviewms:${IMAGE_TAG} || true"
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
