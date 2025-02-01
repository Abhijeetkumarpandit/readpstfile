# Use Python 3.9 as the base image
FROM python:3.9-slim

# Install required system packages
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libtool \
    autoconf \
    libssl-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Download and install libpff
RUN curl -L -o libpff.tar.gz https://github.com/libyal/libpff/releases/latest/download/libpff-alpha-linux.tar.gz && \
    tar -xvzf libpff.tar.gz && \
    cd libpff-* && \
    ./configure && make && make install

# Clone and install pypff
RUN git clone https://github.com/libyal/pypff.git && \
    cd pypff && \
    python setup.py install

# Copy the application files
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port the app runs on
EXPOSE 5000

# Start the Flask app when the container starts
CMD ["python", "extract_pst.py"]
