# Use a minimal Python image
FROM python:3.11-slim

# Set environment variables to avoid Python buffering issues
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies (incl. MuPDF and build tools)
RUN apt-get update && apt-get install -y \
    libmupdf-dev gcc build-essential python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . .

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Expose the port your app runs on (change if not 8000)
EXPOSE 8000

# Start the app (change if your app is in a package)
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8000"]
