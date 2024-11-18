# Review Company Microservices App with DevOps Jenkins CI/CD Pipline, Security with Trivy, SonaryQube and Deploys with Docker and K8s

## Install Jenkins and SonarQube with Docker Compose and Dockerfile

<p align="center">
  <img src="images/docker/install-jenkins-sonarqube.png" alt="Console Output">
  <br>
  <em>Install Dependencies and Build code Succesfully</em>
</p>

## Jenkins Pipeline

<p align="center">
  <img src="images/jenkins/companyms/pipeline-companyms.png" alt="Company Microservices Pipeline Step">
  <br>
  <em>Company Microservices Pipeline Step</em>
</p>

<p align="center">
  <img src="images/jenkins/jobms/pipeline-jobms.png" alt="Job Microservices Pipeline Step">
  <br>
  <em>Job Microservices Pipeline Step</em>
</p>

<p align="center">
  <img src="images/jenkins/reviewms/pipeline-reviewms.png" alt="Review Microservices Pipeline Step">
  <br>
  <em>Review Microservices Pipeline Step</em>
</p>

## Console Output for each Microservies

<p align="center">
  <img src="images/jenkins/companyms/install-deps-and-build-code-companyms.png" alt="Console Output">
  <br>
  <em>Install Dependencies and Build code Succesfully</em>
</p>

<p align="center">
  <img src="images/jenkins/companyms/sonar-scanner-companyms.png" alt="Console Output">
  <br>
  <em>Scan code with Sonar Scanner</em>
</p>

<p align="center">
  <img src="images/jenkins/companyms/trivy-scan-fs-companyms.png" alt="Console Output">
  <br>
  <em>Scan code with Trivy</em>
</p>

<p align="center">
  <img src="images/jenkins/companyms/push-image-to-dockerhub-companyms.png" alt="Console Output">
  <br>
  <em>Login and push docker image to Docker Hub</em>
</p>

<p align="center">
  <img src="images/jenkins/companyms/trivy-scan-dockerimage-companyms.png" alt="Console Output">
  <br>
  <em>Install Dependencies and Build code Succesfully</em>
</p>

<p align="center">
  <img src="images/jenkins/companyms/pipeline-successfully-companyms.png" alt="Console Output">
  <br>
  <em>Pipeline Successfully</em>
</p>

> Console Output tương tự với Job Microservice và Review Microservice.

## SonarQube

<p align="center">
  <img src="images/sonarqube/sonar.png" alt="Sonarqube">
  <br>
  <em>Scan code Company-MS, Job-MS, Review-MS</em>
</p>

## Docker Hub

<p align="center">
  <img src="images/docker/docker-hub.png" alt="Docker Hub">
  <br>
  <em>Docker Hub</em>
</p>

## Minikube 

<p align="center">
  <img src="images/k8s/get-resource-k8s.png" alt="Docker Hub">
  <br>
  <em>Docker Hub</em>
</p>