# Use Python 3.9 as the base image
FROM python:3.9-slim

# Install required system packages for building pypff and libpff
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libtool \
    autoconf \
    libssl-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Download and build libpff
RUN wget https://github.com/libyal/libpff/releases/download/20201006/libpff-20201006.tar.gz && \
    tar -xvzf libpff-20201006.tar.gz && \
    cd libpff-20201006 && \
    ./configure && \
    make && \
    make install

# Install pypff from the source (assuming it's available on GitHub)
RUN git clone https://github.com/libyal/pypff.git && \
    cd pypff && \
    python setup.py install

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port the app runs on
EXPOSE 5000

# Start the Flask app when the container starts
CMD ["python", "extract_pst.py"]
