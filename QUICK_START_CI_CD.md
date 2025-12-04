# 🚀 Quick Start: Complete CI/CD Setup

## ⚡ Fast Track Setup (Automated)

### Step 1: Start Docker Desktop
**IMPORTANT:** Make sure Docker Desktop is running before proceeding!

### Step 2: Run Jenkins Setup Script
```bash
cd CODE
./setup_jenkins.sh
```

This will:
- Build Jenkins Docker image
- Start Jenkins container
- Show you the initial password

### Step 3: Access Jenkins
1. Open browser: **http://localhost:8080**
2. Enter the password shown by the script
3. Install suggested plugins (wait 5-10 minutes)
4. Create admin user or skip

### Step 4: Install Tools in Jenkins
```bash
./install_jenkins_tools.sh
```

This installs:
- Python 3
- Trivy security scanner
- AWS CLI
- Fixes Docker permissions

### Step 5: Manual Configuration (Follow CI_CD_SETUP_GUIDE.md)

1. **GitHub Integration:**
   - Generate GitHub token: https://github.com/settings/tokens
   - Add to Jenkins: Manage Jenkins → Credentials → Add `github-token`

2. **AWS Integration:**
   - Create IAM user with ECR and App Runner permissions
   - Add AWS credentials to Jenkins: `aws-token`
   - Create ECR repository in AWS Console
   - Create App Runner service in AWS Console

3. **Configure Pipeline:**
   - Create pipeline job: `medical-rag-pipeline`
   - Point to your GitHub repo
   - Update Jenkinsfile with your AWS details

4. **Run Pipeline:**
   - Click "Build Now" in Jenkins
   - Watch the magic happen! ✨

---

## 📚 Detailed Instructions

For complete step-by-step instructions, see: **CI_CD_SETUP_GUIDE.md**

---

## ✅ Prerequisites Checklist

- [ ] Docker Desktop installed and **RUNNING**
- [ ] GitHub account with repository
- [ ] AWS account with IAM access
- [ ] HuggingFace token (already set up)

---

## 🎯 What You'll Get

After complete setup:
- ✅ Automated CI/CD pipeline
- ✅ Security scanning with Trivy
- ✅ Docker image in AWS ECR
- ✅ Live deployment on AWS App Runner
- ✅ Automatic deployments on code push

---

## 🆘 Troubleshooting

**Docker not running?**
- Start Docker Desktop
- Wait for it to fully start (whale icon in system tray)

**Jenkins won't start?**
- Check Docker is running: `docker ps`
- Check port 8080 is free: `lsof -ti:5000`

**Need help?**
- See `CI_CD_SETUP_GUIDE.md` for detailed troubleshooting
- Check Jenkins logs: `docker logs jenkins-dind`

