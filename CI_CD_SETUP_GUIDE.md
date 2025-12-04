# 🚀 Complete CI/CD Setup Guide

This guide will walk you through setting up the complete CI/CD pipeline for the Medical RAG Chatbot, including Jenkins, Docker, Trivy, AWS ECR, and AWS App Runner.

## 📋 Prerequisites Checklist

Before starting, ensure you have:

- [x] ✅ **Docker Desktop** installed and running
- [ ] **GitHub Account** with repository access
- [ ] **AWS Account** with appropriate permissions
- [ ] **HuggingFace Token** (already set up)
- [ ] **Project code** ready in local directory

---

## Part 1: 🐳 Jenkins Setup with Docker-in-Docker

### Step 1.1: Build Jenkins Docker Image

```bash
cd custom_jenkins
docker build -t jenkins-dind .
```

### Step 1.2: Run Jenkins Container

**For macOS/Linux:**
```bash
docker run -d \
  --name jenkins-dind \
  --privileged \
  -p 8080:8080 \
  -p 50000:50000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v jenkins_home:/var/jenkins_home \
  jenkins-dind
```

**For Windows (PowerShell):**
```powershell
docker run -d `
  --name jenkins-dind `
  --privileged `
  -p 8080:8080 `
  -p 50000:50000 `
  -v /var/run/docker.sock:/var/run/docker.sock `
  -v jenkins_home:/var/jenkins_home `
  jenkins-dind
```

### Step 1.3: Get Jenkins Initial Password

```bash
# Wait 30-60 seconds for Jenkins to start, then:
docker exec jenkins-dind cat /var/jenkins_home/secrets/initialAdminPassword
```

### Step 1.4: Access Jenkins Dashboard

1. Open browser: **http://localhost:8080**
2. Enter the initial password from Step 1.3
3. Install suggested plugins (wait 5-10 minutes)
4. Create admin user or skip
5. Save and finish

### Step 1.5: Install Python in Jenkins Container

```bash
docker exec -u root -it jenkins-dind bash
apt update -y
apt install -y python3 python3-pip
python3 --version
ln -s /usr/bin/python3 /usr/bin/python
python --version
exit
```

### Step 1.6: Restart Jenkins

```bash
docker restart jenkins-dind
```

---

## Part 2: 🔗 GitHub Integration

### Step 2.1: Generate GitHub Personal Access Token

1. Go to **GitHub** → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. Click **Generate new token (classic)**
3. Name: `Jenkins Integration`
4. Select scopes:
   - ✅ `repo` (full control of private repositories)
   - ✅ `admin:repo_hook` (webhook integration)
5. Click **Generate token**
6. **COPY THE TOKEN** (you won't see it again!)

### Step 2.2: Add GitHub Token to Jenkins

1. Go to **Jenkins Dashboard** → **Manage Jenkins** → **Credentials**
2. Click **(Global)** → **Add Credentials**
3. Fill in:
   - **Kind:** Username with password
   - **Username:** Your GitHub username
   - **Password:** Paste your GitHub token
   - **ID:** `github-token`
   - **Description:** `GitHub Token for Jenkins`
4. Click **Save**

### Step 2.3: Create Pipeline Job

1. Go to **Jenkins Dashboard** → **New Item**
2. Enter name: `medical-rag-pipeline`
3. Select **Pipeline**
4. Click **OK**
5. Scroll down → Click **Save** (we'll configure it later)

### Step 2.4: Update Jenkinsfile (If Needed)

The `Jenkinsfile` is already in the project. Make sure it points to your GitHub repository:

```groovy
checkout scmGit(
    branches: [[name: '*/main']], 
    extensions: [], 
    userRemoteConfigs: [[
        credentialsId: 'github-token', 
        url: 'YOUR_GITHUB_REPO_URL'
    ]]
)
```

### Step 2.5: Push Code to GitHub (If Not Already Done)

```bash
cd CODE
git init  # if not already a git repo
git add .
git commit -m "Initial commit: Medical RAG Chatbot with CI/CD"
git remote add origin YOUR_GITHUB_REPO_URL
git push -u origin main
```

---

## Part 3: 🛡️ Security Scanning with Trivy

### Step 3.1: Install Trivy in Jenkins Container

```bash
docker exec -u root -it jenkins-dind bash
apt install -y curl
curl -LO https://github.com/aquasecurity/trivy/releases/download/v0.62.1/trivy_0.62.1_Linux-64bit.deb
dpkg -i trivy_0.62.1_Linux-64bit.deb
trivy --version
exit
```

### Step 3.2: Restart Jenkins

```bash
docker restart jenkins-dind
```

---

## Part 4: ☁️ AWS Integration

### Step 4.1: Create AWS IAM User

1. Go to **AWS Console** → **IAM** → **Users** → **Add User**
2. Username: `jenkins-deployment-user`
3. Select **Programmatic access**
4. Click **Next: Permissions**
5. Attach policies:
   - ✅ `AmazonEC2ContainerRegistryFullAccess`
   - ✅ `AWSAppRunnerFullAccess`
6. Click **Next** → **Create User**
7. **IMPORTANT:** Copy the **Access Key ID** and **Secret Access Key** (you won't see the secret again!)

### Step 4.2: Add AWS Credentials to Jenkins

1. Go to **Jenkins Dashboard** → **Manage Jenkins** → **Credentials**
2. Click **(Global)** → **Add Credentials**
3. Select **AWS Credentials**
4. Fill in:
   - **Access Key ID:** Your AWS access key
   - **Secret Access Key:** Your AWS secret key
   - **ID:** `aws-token`
   - **Description:** `AWS Credentials for ECR and App Runner`
5. Click **Save**

### Step 4.3: Install AWS CLI in Jenkins Container

```bash
docker exec -u root -it jenkins-dind bash
apt update
apt install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
aws --version
exit
```

### Step 4.4: Create ECR Repository

1. Go to **AWS Console** → **ECR** (Elastic Container Registry)
2. Click **Create repository**
3. Repository name: `medical-rag-chatbot` (or your preferred name)
4. Visibility: **Private**
5. Click **Create repository**
6. **Note the repository URI** (format: `ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/REPO_NAME`)

### Step 4.5: Update Jenkinsfile with Your ECR Details

Edit the `Jenkinsfile` in the `CODE` directory:

```groovy
environment {
    AWS_REGION = 'us-east-1'  // Change to your AWS region
    ECR_REPO = 'medical-rag-chatbot'  // Change to your ECR repo name
    IMAGE_TAG = 'latest'
    SERVICE_NAME = 'llmops-medical-service'  // Change if needed
}
```

### Step 4.6: Fix Docker Permissions (If Needed)

If you encounter Docker permission issues:

```bash
docker exec -u root -it jenkins-dind bash
chown root:docker /var/run/docker.sock
chmod 660 /var/run/docker.sock
getent group docker || groupadd docker
usermod -aG docker jenkins
exit
docker restart jenkins-dind
```

---

## Part 5: 🚀 AWS App Runner Setup

### Step 5.1: Create App Runner Service (Manual)

1. Go to **AWS Console** → **App Runner**
2. Click **Create service**
3. **Source:**
   - Select **Container registry**
   - Provider: **Amazon ECR**
   - Container image URI: Select your ECR repository
   - Deployment trigger: **Automatic** (or Manual)
4. **Configure service:**
   - Service name: `llmops-medical-service`
   - Virtual CPU: **1 vCPU**
   - Memory: **2 GB**
5. **Configure service:**
   - Port: **5000**
   - Environment variables:
     - `HF_TOKEN`: Your HuggingFace token
6. Click **Create & deploy**

**Note:** The first deployment will take 5-10 minutes.

### Step 5.2: Get App Runner Service ARN

After the service is created:
1. Go to your App Runner service
2. Copy the **Service ARN** (you'll need this for the Jenkinsfile)

---

## Part 6: 🎯 Configure Jenkins Pipeline

### Step 6.1: Configure Pipeline in Jenkins UI

1. Go to **Jenkins Dashboard** → **medical-rag-pipeline**
2. Click **Configure**
3. Scroll to **Pipeline** section
4. **Definition:** Pipeline script from SCM
5. **SCM:** Git
6. **Repository URL:** Your GitHub repo URL
7. **Credentials:** Select `github-token`
8. **Branch:** `*/main`
9. **Script Path:** `Jenkinsfile`
10. Click **Save**

### Step 6.2: Update Jenkinsfile (If Needed)

Make sure your `Jenkinsfile` has:
- Correct GitHub repo URL
- Correct AWS region
- Correct ECR repository name
- Correct App Runner service name

---

## Part 7: 🧪 Test the Pipeline

### Step 7.1: Run Pipeline

1. Go to **Jenkins Dashboard** → **medical-rag-pipeline**
2. Click **Build Now**
3. Watch the build progress

### Step 7.2: Verify Stages

The pipeline should execute these stages:
1. ✅ **Clone GitHub Repo** - Clones your code
2. ✅ **Build, Scan, and Push Docker Image to ECR** - Builds Docker image, scans with Trivy, pushes to ECR
3. ✅ **Deploy to AWS App Runner** - Triggers deployment

### Step 7.3: Check Results

- **Jenkins Console Output:** Shows detailed logs
- **ECR Console:** Should show your Docker image
- **App Runner Console:** Should show deployment in progress/completed
- **App Runner URL:** Your app should be accessible via the provided URL

---

## 🔧 Troubleshooting

### Issue: Jenkins can't access Docker
**Solution:** Run the Docker permissions fix (Step 4.6)

### Issue: GitHub authentication fails
**Solution:** 
- Verify GitHub token has correct permissions
- Check token hasn't expired
- Verify credentials ID in Jenkins matches `github-token`

### Issue: AWS authentication fails
**Solution:**
- Verify AWS credentials are correct
- Check IAM user has required permissions
- Verify credentials ID in Jenkinsfile matches `aws-token`

### Issue: ECR push fails
**Solution:**
- Verify ECR repository exists
- Check AWS region matches
- Verify IAM user has `AmazonEC2ContainerRegistryFullAccess`

### Issue: App Runner deployment fails
**Solution:**
- Verify App Runner service exists
- Check service name matches Jenkinsfile
- Verify IAM user has `AWSAppRunnerFullAccess`
- Check App Runner service ARN is correct

### Issue: Trivy scan fails
**Solution:**
- Verify Trivy is installed in Jenkins container
- Check Trivy version compatibility
- The `|| true` in Jenkinsfile allows pipeline to continue even if scan finds issues

---

## 📊 Pipeline Flow Diagram

```
GitHub Push
    ↓
Jenkins Pipeline Triggered
    ↓
Clone Repository
    ↓
Build Docker Image
    ↓
Trivy Security Scan
    ↓
Push to AWS ECR
    ↓
Deploy to AWS App Runner
    ↓
Application Live! 🎉
```

---

## ✅ Final Checklist

- [ ] Jenkins running on http://localhost:8080
- [ ] GitHub token configured in Jenkins
- [ ] AWS credentials configured in Jenkins
- [ ] Trivy installed in Jenkins container
- [ ] AWS CLI installed in Jenkins container
- [ ] ECR repository created
- [ ] App Runner service created
- [ ] Jenkinsfile updated with correct values
- [ ] Pipeline runs successfully
- [ ] Application deployed and accessible

---

## 🎉 Success!

Once all steps are complete, your Medical RAG Chatbot will have:
- ✅ Automated CI/CD pipeline
- ✅ Security scanning with Trivy
- ✅ Docker containerization
- ✅ AWS ECR image registry
- ✅ AWS App Runner deployment
- ✅ Automatic deployments on code push

Your application will be live and accessible via the App Runner URL! 🚀

