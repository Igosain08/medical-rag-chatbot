# Medical RAG Chatbot

A Retrieval-Augmented Generation (RAG) chatbot for medical queries, built with Flask, LangChain, and HuggingFace models.

## 📋 Project Overview

This project is a **Medical Question-Answering Chatbot** that uses:
- **Flask** for the web interface
- **LangChain** for RAG pipeline orchestration
- **HuggingFace Mistral-7B-Instruct** as the LLM
- **FAISS** for vector storage and similarity search
- **Sentence Transformers** for embeddings
- **PDF processing** to create a knowledge base from medical documents

### Architecture

```
User Query → Flask App → RetrievalQA Chain → FAISS Vector Store → LLM → Response
```

1. **PDF Loader**: Loads medical PDFs from `data/` directory
2. **Text Chunking**: Splits documents into manageable chunks
3. **Embeddings**: Converts text chunks to vectors using HuggingFace embeddings
4. **Vector Store**: Stores embeddings in FAISS for fast similarity search
5. **Retriever**: Finds relevant context from vector store
6. **LLM**: Generates answers using Mistral-7B-Instruct model
7. **Web Interface**: Flask-based chat interface

## 🚀 Quick Start Guide

### Prerequisites

- **Python 3.10+** (Python 3.10 or higher)
- **HuggingFace Account** with API token
- **Git** (optional, for version control)

### Step 1: Navigate to Project Directory

```bash
cd CODE
```

### Step 2: Create Virtual Environment

**For macOS/Linux:**
```bash
python3 -m venv venv
source venv/bin/activate
```

**For Windows:**
```bash
python -m venv venv
venv\Scripts\activate
```

### Step 3: Install Dependencies

```bash
pip install -e .
```

Or install directly from requirements.txt:
```bash
pip install -r requirements.txt
```

### Step 4: Set Up Environment Variables

1. Create a `.env` file in the `CODE` directory:
```bash
touch .env
```

2. Add your HuggingFace token:
```
HF_TOKEN=your_huggingface_token_here
```

**How to get HuggingFace Token:**
- Go to https://huggingface.co/settings/tokens
- Create a new token (read access is sufficient)
- Copy the token and paste it in `.env` file

### Step 5: Create Vector Store (IMPORTANT!)

Before running the app, you need to create the vector store from PDFs:

```bash
python -m app.components.data_loader
```

This will:
- Load PDFs from `data/` directory
- Split them into chunks
- Generate embeddings
- Save vector store to `vectorstore/db_faiss/`

**Note:** This step may take 10-30 minutes depending on PDF size and your internet connection (downloading embedding model).

### Step 6: Run the Application

```bash
python app/application.py
```

Or:
```bash
flask run
```

The app will be available at: **http://localhost:5000**

## 📁 Project Structure

```
CODE/
├── app/
│   ├── application.py          # Flask app entry point
│   ├── components/
│   │   ├── data_loader.py      # Main script to create vector store
│   │   ├── pdf_loader.py       # PDF loading and chunking
│   │   ├── embeddings.py       # HuggingFace embeddings
│   │   ├── vector_store.py     # FAISS vector store operations
│   │   ├── retriever.py        # RAG chain creation
│   │   └── llm.py              # LLM loading
│   ├── config/
│   │   └── config.py           # Configuration settings
│   ├── common/
│   │   ├── logger.py           # Logging setup
│   │   └── custom_exception.py # Custom exception handling
│   └── templates/
│       └── index.html          # Chat interface
├── data/
│   └── *.pdf                   # Medical PDF documents
├── vectorstore/
│   └── db_faiss/               # Generated vector store (created after step 5)
├── logs/                       # Application logs (auto-created)
├── requirements.txt            # Python dependencies
├── setup.py                    # Package setup
├── Dockerfile                  # Docker configuration
└── .env                        # Environment variables (create this)
```

## ⚙️ Configuration

Edit `app/config/config.py` to customize:

- `HUGGINGFACE_REPO_ID`: LLM model (default: "mistralai/Mistral-7B-Instruct-v0.3")
- `DB_FAISS_PATH`: Vector store location (default: "vectorstore/db_faiss")
- `DATA_PATH`: PDF directory (default: "data/")
- `CHUNK_SIZE`: Text chunk size (default: 500)
- `CHUNK_OVERLAP`: Overlap between chunks (default: 50)

## 🐳 Docker Setup

### Build Docker Image

```bash
docker build -t medical-rag-chatbot .
```

### Run Docker Container

```bash
docker run -p 5000:5000 --env-file .env medical-rag-chatbot
```

**Note:** Make sure to create the vector store before building the Docker image, or mount the vectorstore directory.

## 🔧 Troubleshooting

### Issue: "Vector store not present or empty"
**Solution:** Run `python -m app.components.data_loader` to create the vector store first.

### Issue: "HF_TOKEN not found"
**Solution:** Create `.env` file with `HF_TOKEN=your_token_here`

### Issue: "No pdfs were found"
**Solution:** Ensure PDF files are in the `data/` directory

### Issue: Slow first response
**Solution:** The embedding model downloads on first use. Subsequent runs will be faster.

### Issue: Import errors
**Solution:** Make sure virtual environment is activated and dependencies are installed: `pip install -e .`

## 📝 Usage

1. Start the application
2. Open browser to http://localhost:5000
3. Type a medical question in the chat interface
4. The bot will retrieve relevant context from the medical encyclopedia and generate an answer
5. Click "Clear Chat" to start a new conversation

## 🔐 Security Notes

- Never commit `.env` file to version control
- Keep your HuggingFace token secure
- The `.env` file is already in `.gitignore` (should be)

## 📚 Dependencies

- `flask`: Web framework
- `langchain`: RAG pipeline
- `langchain_community`: Community integrations
- `langchain_huggingface`: HuggingFace integration
- `faiss-cpu`: Vector similarity search
- `pypdf`: PDF processing
- `huggingface_hub`: HuggingFace API
- `python-dotenv`: Environment variable management

## 🚀 CI/CD Pipeline

The project includes Jenkins CI/CD pipeline for:
- Automated testing
- Docker image building
- Security scanning with Trivy
- Deployment to AWS ECR
- Deployment to AWS App Runner

See `FULL_DOCUMENTATION.md` for detailed CI/CD setup instructions.

## 📄 License

This project is for educational/demonstration purposes.

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

