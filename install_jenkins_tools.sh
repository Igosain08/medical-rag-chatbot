#!/bin/bash

# Install Required Tools in Jenkins Container
# Run this after Jenkins is set up and accessible

set -e

echo "🔧 Installing Tools in Jenkins Container"
echo "========================================="
echo ""

# Check if Jenkins container is running
if ! docker ps | grep -q jenkins-dind; then
    echo "❌ Jenkins container is not running!"
    echo "   Start it with: docker start jenkins-dind"
    exit 1
fi

echo "✅ Jenkins container is running"
echo ""

# Install Python
echo "🐍 Installing Python..."
docker exec -u root jenkins-dind bash -c "
    apt update -y && \
    apt install -y python3 python3-pip && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    python --version && \
    pip3 --version
"
echo "✅ Python installed"
echo ""

# Install Trivy
echo "🛡️  Installing Trivy security scanner..."
docker exec -u root jenkins-dind bash -c "
    apt install -y curl && \
    ARCH=\$(dpkg --print-architecture) && \
    if [ \"\$ARCH\" = \"arm64\" ]; then \
        curl -LO https://github.com/aquasecurity/trivy/releases/download/v0.62.1/trivy_0.62.1_Linux-ARM64.deb && \
        dpkg -i trivy_0.62.1_Linux-ARM64.deb; \
    else \
        curl -LO https://github.com/aquasecurity/trivy/releases/download/v0.62.1/trivy_0.62.1_Linux-64bit.deb && \
        dpkg -i trivy_0.62.1_Linux-64bit.deb; \
    fi && \
    trivy --version
"
echo "✅ Trivy installed"
echo ""

# Install AWS CLI
echo "☁️  Installing AWS CLI..."
docker exec -u root jenkins-dind bash -c "
    apt update && \
    apt install -y unzip curl && \
    ARCH=\$(dpkg --print-architecture) && \
    if [ \"\$ARCH\" = \"arm64\" ]; then \
        curl 'https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip' -o 'awscliv2.zip'; \
    else \
        curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'; \
    fi && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    aws --version
"
echo "✅ AWS CLI installed"
echo ""

# Fix Docker permissions
echo "🔐 Fixing Docker permissions..."
docker exec -u root jenkins-dind bash -c "
    chown root:docker /var/run/docker.sock && \
    chmod 660 /var/run/docker.sock && \
    (getent group docker || groupadd docker) && \
    usermod -aG docker jenkins
"
echo "✅ Docker permissions fixed"
echo ""

# Restart Jenkins
echo "🔄 Restarting Jenkins container..."
docker restart jenkins-dind
echo "✅ Jenkins restarted"
echo ""

echo "======================================"
echo "✅ All Tools Installed Successfully!"
echo "======================================"
echo ""
echo "📝 Installed:"
echo "   ✅ Python 3 + pip"
echo "   ✅ Trivy security scanner"
echo "   ✅ AWS CLI"
echo "   ✅ Docker permissions configured"
echo ""
echo "🌐 Access Jenkins at: http://localhost:8080"
echo ""
echo "📚 Next steps:"
echo "   1. Configure GitHub token in Jenkins"
echo "   2. Configure AWS credentials in Jenkins"
echo "   3. Create ECR repository in AWS"
echo "   4. Create App Runner service in AWS"
echo "   5. Update Jenkinsfile with your details"
echo "   6. Run the pipeline!"
echo ""
echo "See CI_CD_SETUP_GUIDE.md for detailed instructions"
echo ""

