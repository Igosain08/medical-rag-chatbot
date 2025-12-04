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

## Install Python dependencies
RUN pip install --no-cache-dir -e .

## Create vectorstore during build (if data exists)
## This will create the vectorstore from PDFs in the data/ directory
RUN if [ -d "data" ] && [ "$(ls -A data/*.pdf 2>/dev/null)" ]; then \
        echo "Creating vectorstore from PDF data..." && \
        python -m app.components.data_loader || echo "Vectorstore creation failed, app will still start"; \
    else \
        echo "No PDF data found, vectorstore will be created at runtime if needed"; \
    fi

## Make start script executable
RUN chmod +x start.sh

## Expose only flask port
EXPOSE 5000

## Run the Flask app using start script
CMD ["./start.sh"]


