# 📦 Setup GitHub Repository for Medical RAG Chatbot

## Step 1: Create New GitHub Repository

1. Go to **GitHub.com** and sign in
2. Click the **"+"** icon (top right) → **New repository**
3. Fill in:
   - **Repository name:** `medical-rag-chatbot` (or your preferred name)
   - **Description:** `Medical RAG Chatbot with CI/CD Pipeline`
   - **Visibility:** Choose **Private** (recommended) or **Public**
   - **DO NOT** initialize with README, .gitignore, or license (we already have files)
4. Click **Create repository**

## Step 2: Initialize Git in Your Project

Run these commands in your terminal:

```bash
cd "/Users/ishaangosain/Downloads/GSPANN/ALL+MATERIAL+--+MEDICAL+RAG+CHATBOT (1)/CODE"

# Initialize git (if not already initialized)
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Medical RAG Chatbot with CI/CD setup"

# Add your GitHub repo as remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/medical-rag-chatbot.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 3: Update Jenkinsfile

After pushing to GitHub, update the Jenkinsfile:

1. Open `Jenkinsfile`
2. Change line 16 from:
   ```groovy
   url: 'https://github.com/data-guru0/RAG-MEDICAL-CHATBOT.git'
   ```
   To:
   ```groovy
   url: 'https://github.com/YOUR_USERNAME/medical-rag-chatbot.git'
   ```
3. Save the file
4. Commit and push:
   ```bash
   git add Jenkinsfile
   git commit -m "Update Jenkinsfile with correct GitHub repo URL"
   git push
   ```

## Step 4: Update Jenkins Pipeline

1. Go to **Jenkins Dashboard** → **medical-rag-pipeline** → **Configure**
2. Update **Repository URL** to your new repo URL
3. Click **Save**

---

## Quick Checklist

- [ ] Created GitHub repository
- [ ] Initialized git in CODE directory
- [ ] Pushed code to GitHub
- [ ] Updated Jenkinsfile with your repo URL
- [ ] Updated Jenkins pipeline configuration
- [ ] Tested pipeline (should clone your repo successfully)

---

## Troubleshooting

### If you get "repository not found" error:
- Check repository name is correct
- Verify repository is not private (or use SSH/access token)
- Make sure you've pushed code to the repo

### If you get authentication errors:
- Make sure GitHub token is configured in Jenkins
- Verify token has `repo` permissions

