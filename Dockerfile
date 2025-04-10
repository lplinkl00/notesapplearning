# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set environment variables
# Prevents Python from writing pyc files to disc (optional)
ENV PYTHONDONTWRITEBYTECODE 1
# Ensures Python output is sent straight to the terminal without buffering
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
# --no-cache-dir: Disables the cache to keep the image size smaller
# --upgrade pip: Ensures pip is up-to-date
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app
COPY . .

# Get the port number from the environment variable PORT (provided by Cloud Run)
# Default to 8080 if PORT is not set (useful for local testing)
ENV PORT 8080

# Command to run the application using Gunicorn
# We point Gunicorn to the 'app' object inside the 'main.py' file.
# 'main:app' means find the 'app' variable in the 'main.py' module.
# '0.0.0.0' makes the server accessible externally.
# The number of workers can be adjusted based on expected load and instance size.
CMD exec gunicorn --bind 0.0.0.0:$PORT --workers 1 --threads 8 --timeout 0 main:app