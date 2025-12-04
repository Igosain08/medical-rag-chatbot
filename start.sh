#!/bin/bash
set -e

echo "=========================================="
echo "Starting Medical RAG Chatbot"
echo "=========================================="
echo ""

# Check if HF_TOKEN is set
if [ -z "$HF_TOKEN" ]; then
    echo "WARNING: HF_TOKEN environment variable is not set!"
    echo "The app will start but LLM functionality may not work."
    echo ""
else
    echo "✓ HF_TOKEN is set"
fi

# Check if vectorstore exists
if [ -d "vectorstore/db_faiss" ] && [ "$(ls -A vectorstore/db_faiss 2>/dev/null)" ]; then
    echo "✓ Vectorstore found"
else
    echo "WARNING: Vectorstore not found. App will start but queries may fail."
    echo "To create vectorstore, run: python -m app.components.data_loader"
    echo ""
fi

echo ""
echo "Starting Flask application on 0.0.0.0:5000..."
echo "=========================================="
echo ""

# Start Flask app
exec python -u app/application.py

