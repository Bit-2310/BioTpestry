# .devcontainer/Dockerfile
# Start from a base Ubuntu 22.04 container provided by Microsoft
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install system dependencies required for R and Python packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Mambaforge for fast environment management
USER vscode
WORKDIR /home/vscode
RUN wget -q "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh" -O Mambaforge.sh \
    && bash Mambaforge.sh -b -p /opt/conda \
    && rm Mambaforge.sh
ENV PATH="/opt/conda/bin:${PATH}"

# Initialize conda for the vscode user
RUN mamba init bash