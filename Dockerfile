# Use Python 3.9 as the base image instead of 3.8
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install system dependencies for pypff
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libpff-dev \
    && rm -rf /var/lib/apt/lists/*

# Install any needed Python packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port the app runs on
EXPOSE 5000

# Start the Flask app when the container starts
CMD ["python", "extract_pst.py"]
