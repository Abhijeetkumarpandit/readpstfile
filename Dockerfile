# Use Ubuntu 20.04 with Python 3.9
FROM ubuntu:20.04

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages before compiling libpff
RUN apt-get update && apt-get install -y \
    python3.9 python3.9-dev python3.9-distutils python3-pip \
    autoconf automake autopoint libtool pkg-config \
    gcc make git wget unzip \
    && rm -rf /var/lib/apt/lists/*

# Clone, build, and install libpff
RUN git clone https://github.com/libyal/libpff.git && \
    cd libpff && \
    ./autogen.sh && \
    ./configure && \
    make -j$(nproc) && \
    make install

# Install pypff using pip
RUN pip3 install pypff

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Set entrypoint
CMD ["python3.9", "extract_pst.py"]
