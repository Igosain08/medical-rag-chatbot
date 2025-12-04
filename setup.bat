@echo off
REM Medical RAG Chatbot Setup Script for Windows
REM This script automates the initial setup process

echo.
echo ======================================
echo  Medical RAG Chatbot - Setup Script
echo ======================================
echo.

REM Check Python version
echo Checking Python version...
python --version
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    pause
    exit /b 1
)
echo.

REM Create virtual environment
echo Creating virtual environment...
if not exist "venv" (
    python -m venv venv
    echo Virtual environment created
) else (
    echo Virtual environment already exists
)
echo.

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat
echo Virtual environment activated
echo.

REM Upgrade pip
echo Upgrading pip...
python -m pip install --upgrade pip >nul 2>&1
echo pip upgraded
echo.

REM Install dependencies
echo Installing dependencies...
pip install -e .
echo Dependencies installed
echo.

REM Check for .env file
echo Checking environment variables...
if not exist ".env" (
    echo .env file not found!
    echo Creating .env file...
    echo HF_TOKEN=your_huggingface_token_here > .env
    echo .env file created
    echo.
    echo IMPORTANT: Please edit .env file and add your HuggingFace token:
    echo   1. Get token from: https://huggingface.co/settings/tokens
    echo   2. Edit .env file and replace 'your_huggingface_token_here' with your actual token
    echo.
    pause
) else (
    findstr /C:"your_huggingface_token_here" .env >nul 2>&1
    if errorlevel 1 (
        echo .env file found and configured
    ) else (
        echo .env file exists but contains placeholder token!
        echo Please update .env with your actual HuggingFace token
        pause
    )
)
echo.

REM Check for data directory
echo Checking data directory...
if not exist "data" (
    echo data\ directory not found! Creating it...
    mkdir data
    echo data\ directory created
    echo Please add PDF files to the data\ directory
) else (
    dir /b data\*.pdf >nul 2>&1
    if errorlevel 1 (
        echo No PDF files found in data\ directory
        echo Please add PDF files to process
    ) else (
        echo PDF files found in data\ directory
    )
)
echo.

REM Check for vector store
echo Checking vector store...
if not exist "vectorstore\db_faiss" (
    echo Vector store not found!
    echo.
    echo Next step: Create vector store from PDFs
    echo This will take 10-30 minutes depending on PDF size
    echo.
    set /p create_vectorstore="Do you want to create the vector store now? (y/n): "
    if /i "%create_vectorstore%"=="y" (
        echo.
        echo Creating vector store...
        python -m app.components.data_loader
        echo.
        echo Vector store created successfully!
    ) else (
        echo You can create the vector store later by running:
        echo    python -m app.components.data_loader
    )
) else (
    echo Vector store already exists
)
echo.

REM Summary
echo ======================================
echo Setup Complete!
echo ======================================
echo.
echo Summary:
echo   Virtual environment: Created and activated
echo   Dependencies: Installed
echo   Environment variables: Configured
echo.
echo Next Steps:
if not exist "vectorstore\db_faiss" (
    echo   1. Create vector store: python -m app.components.data_loader
    echo   2. Run the app: python app\application.py
) else (
    echo   1. Run the app: python app\application.py
    echo   2. Open browser: http://localhost:5000
)
echo.
echo Tips:
echo   - Make sure .env file has your HuggingFace token
echo   - Add PDF files to data\ directory if needed
echo   - Check logs\ directory for application logs
echo.
pause

