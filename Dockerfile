FROM python:3.11-slim

# Install system dependencies required for Prophet / Stan
RUN apt-get update && apt-get install -y \
    build-essential \
    gfortran \
    git \
    curl \
    libatlas-base-dev \
    && rm -rf /var/lib/apt/lists/*

# Create workdir
WORKDIR /app

# Copy and install Python dependencies
COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy your app code
COPY . .

# Expose port
EXPOSE 3000

# Start your app
CMD ["gunicorn", "--worker-class", "eventlet", "-w", "1", "-b", "0.0.0.0:3000", "app:app"]
