## Parent image
FROM python:3.10-slim

## Essential environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

## Work directory inside the docker container
WORKDIR /app

## Installing system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

## Copying all contents from local to container
COPY . .

## Copy vectorstore if it exists (needed for the app to run)
COPY vectorstore/ vectorstore/ 2>/dev/null || echo "Vectorstore will be created at runtime if needed"

## Install Python dependencies
RUN pip install --no-cache-dir -e .

## Create vectorstore during build (if data exists)
RUN if [ -d "data" ] && [ "$(ls -A data/*.pdf 2>/dev/null)" ]; then \
        python -m app.components.data_loader || echo "Vectorstore creation skipped or failed"; \
    else \
        echo "No PDF data found, vectorstore will be empty"; \
    fi

## Expose only flask port
EXPOSE 5000

## Run the Flask app
CMD ["python", "app/application.py"]


