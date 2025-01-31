# Use an official Python runtime as a parent image
FROM python:3.8-slim

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

# Run the Flask app
CMD ["python", "extract_pst.py"]
