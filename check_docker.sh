#!/bin/bash

# Quick script to check Docker status

echo "🔍 Checking Docker Status..."
echo ""

if command -v docker &> /dev/null; then
    echo "✅ Docker is installed"
else
    echo "❌ Docker is not installed"
    echo "   Please install Docker Desktop from: https://www.docker.com/products/docker-desktop"
    exit 1
fi

echo ""

if docker info >/dev/null 2>&1; then
    echo "✅ Docker is running"
    echo ""
    echo "🚀 You can now run: ./setup_jenkins.sh"
    exit 0
else
    echo "❌ Docker is not running"
    echo ""
    echo "📝 To start Docker Desktop:"
    echo "   1. Open Applications folder"
    echo "   2. Double-click 'Docker'"
    echo "   3. Wait for Docker to start (whale icon in menu bar)"
    echo "   4. Then run: ./setup_jenkins.sh"
    exit 1
fi

