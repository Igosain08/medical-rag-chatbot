#!/bin/bash

# Medical RAG Chatbot Setup Script
# This script automates the initial setup process

set -e  # Exit on error

echo "🏥 Medical RAG Chatbot - Setup Script"
echo "======================================"
echo ""

# Check Python version
echo "📋 Checking Python version..."
python_version=$(python3 --version 2>&1 | awk '{print $2}' | cut -d. -f1,2)
required_version="3.10"

if [ "$(printf '%s\n' "$required_version" "$python_version" | sort -V | head -n1)" != "$required_version" ]; then
    echo "❌ Error: Python 3.10+ is required. Found: $python_version"
    exit 1
fi
echo "✅ Python version: $python_version"
echo ""

# Create virtual environment
echo "🔧 Creating virtual environment..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo "✅ Virtual environment created"
else
    echo "ℹ️  Virtual environment already exists"
fi
echo ""

# Activate virtual environment
echo "🔌 Activating virtual environment..."
source venv/bin/activate
echo "✅ Virtual environment activated"
echo ""

# Upgrade pip
echo "📦 Upgrading pip..."
pip install --upgrade pip > /dev/null 2>&1
echo "✅ pip upgraded"
echo ""

# Install dependencies
echo "📥 Installing dependencies..."
pip install -e .
echo "✅ Dependencies installed"
echo ""

# Check for .env file
echo "🔐 Checking environment variables..."
if [ ! -f ".env" ]; then
    echo "⚠️  .env file not found!"
    echo "📝 Creating .env file from template..."
    cp .env.example .env 2>/dev/null || echo "HF_TOKEN=your_huggingface_token_here" > .env
    echo "✅ .env file created"
    echo ""
    echo "⚠️  IMPORTANT: Please edit .env file and add your HuggingFace token:"
    echo "   1. Get token from: https://huggingface.co/settings/tokens"
    echo "   2. Edit .env file: nano .env (or use your preferred editor)"
    echo "   3. Replace 'your_huggingface_token_here' with your actual token"
    echo ""
    read -p "Press Enter after you've added your HF_TOKEN to .env file..."
else
    if grep -q "your_huggingface_token_here" .env; then
        echo "⚠️  .env file exists but contains placeholder token!"
        echo "   Please update .env with your actual HuggingFace token"
        read -p "Press Enter after you've updated your HF_TOKEN in .env file..."
    else
        echo "✅ .env file found and configured"
    fi
fi
echo ""

# Check for data directory
echo "📚 Checking data directory..."
if [ ! -d "data" ]; then
    echo "⚠️  data/ directory not found! Creating it..."
    mkdir -p data
    echo "✅ data/ directory created"
    echo "⚠️  Please add PDF files to the data/ directory"
else
    pdf_count=$(find data -name "*.pdf" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$pdf_count" -eq 0 ]; then
        echo "⚠️  No PDF files found in data/ directory"
        echo "   Please add PDF files to process"
    else
        echo "✅ Found $pdf_count PDF file(s) in data/ directory"
    fi
fi
echo ""

# Check for vector store
echo "🔍 Checking vector store..."
if [ ! -d "vectorstore/db_faiss" ]; then
    echo "⚠️  Vector store not found!"
    echo ""
    echo "📊 Next step: Create vector store from PDFs"
    echo "   This will take 10-30 minutes depending on PDF size"
    echo ""
    read -p "Do you want to create the vector store now? (y/n): " create_vectorstore
    if [ "$create_vectorstore" = "y" ] || [ "$create_vectorstore" = "Y" ]; then
        echo ""
        echo "🔄 Creating vector store..."
        python -m app.components.data_loader
        echo ""
        echo "✅ Vector store created successfully!"
    else
        echo "ℹ️  You can create the vector store later by running:"
        echo "   python -m app.components.data_loader"
    fi
else
    echo "✅ Vector store already exists"
fi
echo ""

# Summary
echo "======================================"
echo "✅ Setup Complete!"
echo "======================================"
echo ""
echo "📝 Summary:"
echo "  ✅ Virtual environment: Created and activated"
echo "  ✅ Dependencies: Installed"
echo "  ✅ Environment variables: Configured"
echo ""
echo "🚀 Next Steps:"
if [ ! -d "vectorstore/db_faiss" ]; then
    echo "  1. Create vector store: python -m app.components.data_loader"
    echo "  2. Run the app: python app/application.py"
else
    echo "  1. Run the app: python app/application.py"
    echo "  2. Open browser: http://localhost:5000"
fi
echo ""
echo "💡 Tips:"
echo "  - Make sure .env file has your HuggingFace token"
echo "  - Add PDF files to data/ directory if needed"
echo "  - Check logs/ directory for application logs"
echo ""

