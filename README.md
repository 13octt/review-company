# Review Company Microservices App with DevOps Tools (Jenkins, Docker, K3S) Intergated With Security (SonarQube, Trivy) and Monitoring (Prometheus, Grafana) 

## System building process

<p align="center">
  <img src="images/project-images/nt548-diagram (1).png" alt="Console Output">
  <br>
  <em>System building process</em>
</p>

## Demo
https://drive.google.com/drive/folders/1SB27Nu54opv8osg-UCYNrRhS6b0_iMfX?usp=drive_link

## Create Infrastructure with CloudFormation Stack

<p align="center">
  <img src="images/project-images/cloudformation-stack.png" alt="Console Output">
  <br>
  <em>Cloud Formation Stack</em>
</p>

<p align="center">
  <img src="images/project-images/vpc-stack.png" alt="Console Output">
  <br>
  <em>VPC Stack</em>
</p>

<p align="center">
  <img src="images/project-images/ec2-stack.png" alt="Console Output">
  <br>
  <em>EC2 Stack</em>
</p>

## Jenkins Pipeline

<p align="center">
  <img src="images/project-images/jenkins-pipeline.png" alt="Company Microservices Pipeline Step">
  <br>
  <em>Jenkins Pipeline CI/CD</em>
</p>

<p align="center">
  <img src="images/project-images/pipeline-companyms.png" alt="Company Microservices Pipeline Step">
  <br>
  <em>Company Microservices Pipeline Step</em>
</p>

<p align="center">
  <img src="images/project-images/pipeline-jobms.png" alt="Company Microservices Pipeline Step">
  <br>
  <em>Job Microservices Pipeline Step</em>
</p>

<p align="center">
  <img src="images/project-images/pipeline-reviewms.png" alt="Company Microservices Pipeline Step">
  <br>
  <em>Review Microservices Pipeline Step</em>
</p>

<p align="center">
  <img src="images/project-images/deploy-to-k3s-stage.png" alt="Company Microservices Pipeline Step">
  <br>
  <em>Company Microservices Pipeline Step</em>
</p>

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

## K3S

<p align="center">
  <img src="images/project-images/config-ns-token.png" alt="Docker Hub">
  <br>
  <em>K3S Config</em>
</p>

<p align="center">
  <img src="images/project-images/k3s-get-all.png" alt="Docker Hub">
  <br>
  <em>Resource K3S</em>
</p>

## Prometheus

<p align="center">
  <img src="images/project-images/prometheus.png" alt="Docker Hub">
  <br>
  <em>Prometheus Job</em>
</p>

## Grafana

<p align="center">
  <img src="images/project-images/node-exporter.png" alt="Docker Hub">
  <br>
  <em>Node Exporter Dashboard</em>
</p>

<p align="center">
  <img src="images/project-images/microservices-monitor.png" alt="Docker Hub">
  <br>
  <em>Microservices Application Dashboard</em>
</p>


