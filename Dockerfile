# Use an Ubuntu base image with Python 3.9
FROM ubuntu:20.04

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install Python 3.9 and required dependencies
RUN apt-get update && apt-get install -y \
    python3.9 \
    python3.9-dev \
    python3.9-distutils \
    python3-pip \
    autoconf \
    automake \
    autopoint \
    libtool \
    pkg-config \
    gcc \
    make \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install libpff from source
RUN git clone https://github.com/libyal/libpff.git && \
    cd libpff && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

# Install pypff with pip
RUN pip3 install pypff

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Set entrypoint
CMD ["python3.9", "extract_pst.py"]
