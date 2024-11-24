FROM jenkins/jenkins:lts

USER root

# Install curl and other dependencies
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    && curl -sfL https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_Linux-64bit.deb -o trivy.deb \
    && sudo dpkg -i trivy.deb \
    && rm trivy.deb

RUN apt-get update && apt-get install -y \
    curl \
    && curl -LO "https://dl.k8s.io/release/v1.29.0/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# Switch back to the Jenkins user
USER jenkins

# Expose Jenkins default port
EXPOSE 8080
