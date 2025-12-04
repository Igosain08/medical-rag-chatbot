#!/bin/bash

# Jenkins Setup Script for Medical RAG Chatbot CI/CD
# This script automates the Jenkins Docker setup

set -e

echo "🚀 Jenkins CI/CD Setup Script"
echo "=============================="
echo ""

# Check Docker
echo "📋 Checking Docker..."
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker Desktop first."
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "❌ Docker is not running. Please start Docker Desktop."
    exit 1
fi
echo "✅ Docker is installed and running"
echo ""

# Check if Jenkins container already exists
if docker ps -a | grep -q jenkins-dind; then
    echo "⚠️  Jenkins container already exists"
    read -p "Do you want to remove the existing container and start fresh? (y/n): " remove_existing
    if [ "$remove_existing" = "y" ] || [ "$remove_existing" = "Y" ]; then
        echo "🗑️  Stopping and removing existing container..."
        docker stop jenkins-dind 2>/dev/null || true
        docker rm jenkins-dind 2>/dev/null || true
        echo "✅ Existing container removed"
    else
        echo "ℹ️  Using existing Jenkins container"
        echo "   To access Jenkins: http://localhost:8080"
        echo "   To get password: docker exec jenkins-dind cat /var/jenkins_home/secrets/initialAdminPassword"
        exit 0
    fi
    echo ""
fi

# Navigate to custom_jenkins directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JENKINS_DIR="$SCRIPT_DIR/custom_jenkins"

if [ ! -d "$JENKINS_DIR" ]; then
    echo "❌ custom_jenkins directory not found!"
    exit 1
fi

cd "$JENKINS_DIR"

# Build Jenkins image
echo "🔨 Building Jenkins Docker image..."
docker build -t jenkins-dind .
echo "✅ Jenkins image built successfully"
echo ""

# Run Jenkins container
echo "🚀 Starting Jenkins container..."
docker run -d \
  --name jenkins-dind \
  --privileged \
  -p 8080:8080 \
  -p 50000:50000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v jenkins_home:/var/jenkins_home \
  jenkins-dind

echo "✅ Jenkins container started"
echo ""

# Wait for Jenkins to initialize
echo "⏳ Waiting for Jenkins to initialize (30 seconds)..."
sleep 30

# Get initial password
echo "🔐 Getting Jenkins initial admin password..."
INITIAL_PASSWORD=$(docker exec jenkins-dind cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null || echo "Password not available yet")

echo ""
echo "======================================"
echo "✅ Jenkins Setup Complete!"
echo "======================================"
echo ""
echo "📝 Next Steps:"
echo "   1. Open browser: http://localhost:8080"
echo "   2. Enter initial password: $INITIAL_PASSWORD"
echo "   3. Install suggested plugins"
echo "   4. Create admin user (or skip)"
echo ""
echo "🔧 To install Python in Jenkins container, run:"
echo "   docker exec -u root -it jenkins-dind bash"
echo "   apt update -y && apt install -y python3 python3-pip"
echo "   ln -s /usr/bin/python3 /usr/bin/python"
echo "   exit"
echo "   docker restart jenkins-dind"
echo ""
echo "📚 For complete setup instructions, see: CI_CD_SETUP_GUIDE.md"
echo ""

