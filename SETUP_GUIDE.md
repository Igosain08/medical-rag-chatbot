# 🚀 Step-by-Step Setup Guide

This guide will walk you through setting up the Medical RAG Chatbot from scratch.

## 📋 Prerequisites Checklist

Before starting, ensure you have:
- [ ] Python 3.10+ installed (you have Python 3.9.6 - may need to upgrade)
- [ ] Internet connection (for downloading models and dependencies)
- [ ] HuggingFace account (free account works)
- [ ] 2-3 GB free disk space (for models and vector store)

---

## Step 1: Navigate to Project Directory

```bash
cd "/Users/ishaangosain/Downloads/GSPANN/ALL+MATERIAL+--+MEDICAL+RAG+CHATBOT (1)/CODE"
```

Or simply:
```bash
cd CODE
```

---

## Step 2: Create Virtual Environment

**For macOS (your system):**
```bash
python3 -m venv venv
source venv/bin/activate
```

You should see `(venv)` in your terminal prompt after activation.

**Note:** If you get an error, try:
```bash
python -m venv venv
source venv/bin/activate
```

---

## Step 3: Install Dependencies

```bash
pip install --upgrade pip
pip install -e .
```

This will install:
- Flask (web framework)
- LangChain (RAG pipeline)
- FAISS (vector search)
- HuggingFace libraries
- PDF processing libraries

**Expected time:** 2-5 minutes depending on internet speed

---

## Step 4: Get HuggingFace Token

1. Go to https://huggingface.co/join (create account if needed)
2. After login, go to https://huggingface.co/settings/tokens
3. Click "New token"
4. Give it a name (e.g., "medical-chatbot")
5. Select "Read" access (sufficient for this project)
6. Click "Generate token"
7. **COPY THE TOKEN** (you won't see it again!)

---

## Step 5: Create .env File

Create a file named `.env` in the `CODE` directory:

```bash
touch .env
```

Then open it in a text editor and add:
```
HF_TOKEN=your_actual_token_here
```

Replace `your_actual_token_here` with the token you copied from Step 4.

**Example:**
```
HF_TOKEN=hf_abc123xyz789...
```

---

## Step 6: Verify PDF Data

Check that the PDF file exists:
```bash
ls -la data/
```

You should see: `The_GALE_ENCYCLOPEDIA_of_MEDICINE_SECOND.pdf`

---

## Step 7: Create Vector Store (IMPORTANT!)

This is the most time-consuming step (10-30 minutes). It will:
- Download the embedding model (~80MB)
- Process the PDF file
- Create embeddings for all text chunks
- Save the vector store

**Run:**
```bash
python -m app.components.data_loader
```

**What to expect:**
- First run will download the embedding model (one-time)
- Processing may take 15-30 minutes for large PDFs
- You'll see progress logs
- Final message: "Vectorstore created successfully...."

**Troubleshooting:**
- If you get "HF_TOKEN not found": Check your `.env` file
- If you get "No pdfs were found": Check `data/` directory
- If it's very slow: This is normal for large PDFs

---

## Step 8: Run the Application

Once the vector store is created, start the Flask app:

```bash
python app/application.py
```

You should see:
```
 * Running on http://0.0.0.0:5000
```

---

## Step 9: Access the Chatbot

1. Open your web browser
2. Go to: **http://localhost:5000**
3. You should see the chat interface
4. Try asking a medical question like:
   - "What is diabetes?"
   - "Explain hypertension"
   - "What are the symptoms of flu?"

---

## ✅ Verification Checklist

After setup, verify everything works:

- [ ] Virtual environment is activated (see `(venv)` in prompt)
- [ ] Dependencies installed (`pip list` shows all packages)
- [ ] `.env` file exists with valid HF_TOKEN
- [ ] Vector store created (`vectorstore/db_faiss/` directory exists)
- [ ] Flask app runs without errors
- [ ] Browser can access http://localhost:5000
- [ ] Chatbot responds to questions

---

## 🐛 Common Issues & Solutions

### Issue: "Python 3.10+ required"
**Solution:** 
- Install Python 3.10+ from python.org
- Or use pyenv: `pyenv install 3.10.0 && pyenv local 3.10.0`

### Issue: "ModuleNotFoundError"
**Solution:**
```bash
pip install -r requirements.txt
```

### Issue: "HF_TOKEN not found"
**Solution:**
- Check `.env` file exists in `CODE/` directory
- Verify token format: `HF_TOKEN=hf_...` (no spaces around `=`)
- Make sure you're in the `CODE` directory when running

### Issue: "Vector store not found"
**Solution:**
- Run: `python -m app.components.data_loader`
- Wait for it to complete (can take 20-30 minutes)

### Issue: "Port 5000 already in use"
**Solution:**
- Find and kill the process: `lsof -ti:5000 | xargs kill`
- Or change port in `application.py`: `app.run(port=5001)`

### Issue: Slow responses
**Solution:**
- First query is slow (model loading)
- Subsequent queries should be faster
- Check internet connection (uses HuggingFace API)

---

## 📊 Project Structure After Setup

```
CODE/
├── venv/                    # Virtual environment (created)
├── .env                     # Your environment variables (created)
├── vectorstore/             # Vector store (created after Step 7)
│   └── db_faiss/           # FAISS database
├── logs/                    # Application logs (auto-created)
├── app/                     # Application code
├── data/                    # PDF files
└── ...                      # Other files
```

---

## 🎯 Quick Start (After Initial Setup)

Once everything is set up, to run the app again:

```bash
cd CODE
source venv/bin/activate  # macOS/Linux
# OR: venv\Scripts\activate  # Windows
python app/application.py
```

---

## 📝 Next Steps

After successful setup:
1. ✅ Test the chatbot with various medical questions
2. ✅ Check logs in `logs/` directory for any issues
3. ✅ Customize the prompt in `app/components/retriever.py`
4. ✅ Add more PDFs to `data/` directory (re-run Step 7)
5. ✅ Explore Docker setup (see README.md)
6. ✅ Set up CI/CD pipeline (see FULL_DOCUMENTATION.md)

---

## 🆘 Need Help?

- Check `README.md` for detailed documentation
- Review logs in `logs/` directory
- Check HuggingFace token is valid: https://huggingface.co/settings/tokens
- Verify all dependencies: `pip list`

---

**Happy Chatting! 🏥💬**

