# 🎯 Next Steps After Jenkins Setup (Step 2 Complete)

You've completed Jenkins setup! Here's what to do next, step by step.

---

## ✅ STEP 3: Install Required Tools in Jenkins Container

**Run this command in your terminal:**

```bash
cd CODE
./install_jenkins_tools.sh
```

**What this does:**
- Installs Python 3 + pip
- Installs Trivy security scanner
- Installs AWS CLI
- Fixes Docker permissions
- Restarts Jenkins

**Expected time:** 2-3 minutes

**After completion, you'll see:**
```
✅ All Tools Installed Successfully!
```

---

## ✅ STEP 4: Configure Jenkins Dashboard

### 4.1: Access Jenkins (If Not Already Done)

1. **Open browser:** http://localhost:8080
2. **Enter initial password:** (Get it with: `docker exec jenkins-dind cat /var/jenkins_home/secrets/initialAdminPassword`)
3. **Install suggested plugins** (wait 5-10 minutes)
4. **Create admin user** or **Skip** to use default admin

### 4.2: Install AWS Plugins in Jenkins

1. Go to **Jenkins Dashboard** → **Manage Jenkins** → **Plugins**
2. Click **Available** tab
3. Search and install:
   - **AWS SDK**
   - **AWS Credentials**
4. Click **Install without restart** or **Download now and install after restart**
5. Wait for installation to complete
6. **Restart Jenkins** if prompted

---

## ✅ STEP 5: GitHub Integration

### 5.1: Generate GitHub Personal Access Token

1. Go to: **https://github.com/settings/tokens**
2. Click **Generate new token (classic)**
3. **Token name:** `Jenkins Integration`
4. **Expiration:** Choose your preference (90 days recommended)
5. **Select scopes:**
   - ✅ **repo** (Full control of private repositories)
   - ✅ **admin:repo_hook** (Full control of repository hooks)
6. Click **Generate token**
7. **⚠️ COPY THE TOKEN IMMEDIATELY** (you won't see it again!)
   - It starts with `ghp_...`

### 5.2: Add GitHub Token to Jenkins

1. Go to **Jenkins Dashboard** → **Manage Jenkins** → **Credentials**
2. Click **(Global)** → **Add Credentials**
3. Fill in:
   - **Kind:** Username with password
   - **Username:** Your GitHub username
   - **Password:** Paste your GitHub token (the `ghp_...` token)
   - **ID:** `github-token` (must be exactly this)
   - **Description:** `GitHub Token for Jenkins`
4. Click **Save**

### 5.3: Create Pipeline Job in Jenkins

1. Go to **Jenkins Dashboard** → **New Item**
2. **Item name:** `medical-rag-pipeline`
3. Select **Pipeline**
4. Click **OK**
5. Scroll down → Click **Save** (we'll configure it in Step 7)

---

## ✅ STEP 6: AWS Setup

### 6.1: Create AWS IAM User

1. Go to **AWS Console** → **IAM** → **Users** → **Add User**
2. **User name:** `jenkins-deployment-user`
3. Select **Provide user access to the AWS Management Console** → **Programmatic access**
4. Click **Next**
5. **Set permissions:** Select **Attach policies directly**
6. **Search and select:**
   - ✅ `AmazonEC2ContainerRegistryFullAccess`
   - ✅ `AWSAppRunnerFullAccess`
7. Click **Next** → **Next** → **Create user**
8. **⚠️ IMPORTANT:** Copy both:
   - **Access Key ID** (starts with `AKIA...`)
   - **Secret Access Key** (you won't see this again!)
   - Click **Download .csv** to save them

### 6.2: Add AWS Credentials to Jenkins

1. Go to **Jenkins Dashboard** → **Manage Jenkins** → **Credentials**
2. Click **(Global)** → **Add Credentials**
3. **Kind:** Select **AWS Credentials**
4. Fill in:
   - **Access Key ID:** Your AWS Access Key ID
   - **Secret Access Key:** Your AWS Secret Access Key
   - **ID:** `aws-token` (must be exactly this)
   - **Description:** `AWS Credentials for ECR and App Runner`
5. Click **Save**

### 6.3: Create ECR Repository

1. Go to **AWS Console** → **ECR** (Elastic Container Registry)
2. Make sure you're in the correct **region** (e.g., `us-east-1`)
3. Click **Create repository**
4. **Repository name:** `medical-rag-chatbot`
5. **Visibility settings:** Private
6. Click **Create repository**
7. **⚠️ COPY THE REPOSITORY URI** (format: `ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/medical-rag-chatbot`)

### 6.4: Update Jenkinsfile with Your Details

1. Open `CODE/Jenkinsfile` in your editor
2. Update the `environment` section:

```groovy
environment {
    AWS_REGION = 'us-east-1'  // Change to your AWS region
    ECR_REPO = 'medical-rag-chatbot'  // Your ECR repo name
    IMAGE_TAG = 'latest'
    SERVICE_NAME = 'llmops-medical-service'
}
```

3. **Also update the GitHub URL** in the checkout section (line 16):
   - Change `https://github.com/data-guru0/RAG-MEDICAL-CHATBOT.git` to **your GitHub repo URL**

4. **Save the file**

---

## ✅ STEP 7: Configure Jenkins Pipeline

### 7.1: Configure Pipeline Job

1. Go to **Jenkins Dashboard** → **medical-rag-pipeline**
2. Click **Configure**
3. Scroll to **Pipeline** section
4. **Definition:** Select **Pipeline script from SCM**
5. **SCM:** Select **Git**
6. **Repository URL:** Your GitHub repository URL
7. **Credentials:** Select `github-token` from dropdown
8. **Branch Specifier:** `*/main` (or `*/master` if your main branch is master)
9. **Script Path:** `Jenkinsfile` (should be default)
10. Click **Save**

---

## ✅ STEP 8: AWS App Runner Setup (Manual)

### 8.1: Create App Runner Service

1. Go to **AWS Console** → **App Runner**
2. Click **Create service**
3. **Source:**
   - Select **Container registry**
   - **Provider:** Amazon ECR
   - **Container image URI:** Click **Browse** and select your `medical-rag-chatbot` repository
   - **Deployment trigger:** Automatic (or Manual)
4. **Configure service:**
   - **Service name:** `llmops-medical-service`
   - **Virtual CPU:** 1 vCPU
   - **Memory:** 2 GB
5. **Configure service:**
   - **Port:** `5000`
   - **Environment variables:**
     - **Key:** `HF_TOKEN`
     - **Value:** Your HuggingFace token (from `.env` file)
6. Click **Next** → **Create & deploy**

**⏳ Wait 5-10 minutes for the first deployment**

### 8.2: Get App Runner Service ARN

1. After service is created, go to your App Runner service
2. Copy the **Service ARN** (you'll need this if you want to update the Jenkinsfile)
   - Format: `arn:aws:apprunner:REGION:ACCOUNT_ID:service/SERVICE_NAME/...`

---

## ✅ STEP 9: Test the Pipeline

### 9.1: Run Your First Pipeline Build

1. Go to **Jenkins Dashboard** → **medical-rag-pipeline**
2. Click **Build Now**
3. Watch the build progress:
   - Click on the build number (#1)
   - Click **Console Output** to see detailed logs

### 9.2: Verify Each Stage

The pipeline should execute:
1. ✅ **Clone GitHub Repo** - Downloads your code
2. ✅ **Build, Scan, and Push Docker Image to ECR** - Builds Docker image, scans with Trivy, pushes to ECR
3. ✅ **Deploy to AWS App Runner** - Triggers deployment

### 9.3: Check Results

- **Jenkins:** Should show ✅ SUCCESS
- **AWS ECR:** Should show your Docker image
- **AWS App Runner:** Should show deployment in progress/completed
- **App Runner URL:** Your app should be accessible!

---

## 🎉 Success Checklist

- [ ] Jenkins running on http://localhost:8080
- [ ] Tools installed in Jenkins (Python, Trivy, AWS CLI)
- [ ] GitHub token configured in Jenkins
- [ ] AWS credentials configured in Jenkins
- [ ] ECR repository created
- [ ] Jenkinsfile updated with your details
- [ ] Pipeline job created and configured
- [ ] App Runner service created
- [ ] Pipeline runs successfully
- [ ] Application deployed and accessible

---

## 🆘 Troubleshooting

### Pipeline fails at "Clone GitHub Repo"
- Check GitHub token is correct
- Verify credentials ID is `github-token`
- Check GitHub repo URL is correct

### Pipeline fails at "Build Docker Image"
- Check Docker is accessible in Jenkins container
- Run: `docker exec jenkins-dind docker ps` (should work)

### Pipeline fails at "Push to ECR"
- Verify AWS credentials are correct
- Check ECR repository name matches Jenkinsfile
- Verify AWS region is correct
- Check IAM user has `AmazonEC2ContainerRegistryFullAccess`

### Pipeline fails at "Deploy to App Runner"
- Verify App Runner service exists
- Check service name matches Jenkinsfile
- Verify IAM user has `AWSAppRunnerFullAccess`

---

## 📞 Quick Commands

```bash
# Check Jenkins status
docker ps | grep jenkins-dind

# Get Jenkins password
docker exec jenkins-dind cat /var/jenkins_home/secrets/initialAdminPassword

# View Jenkins logs
docker logs jenkins-dind

# Restart Jenkins
docker restart jenkins-dind

# Test Docker in Jenkins
docker exec jenkins-dind docker ps
```

---

**You're all set! Follow these steps in order and you'll have a complete CI/CD pipeline! 🚀**

