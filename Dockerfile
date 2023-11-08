# Use the official Ubuntu 20.04 base image
FROM ubuntu:20.04

# Set the Dockerfile author/maintainer label
LABEL maintainer="KhulnaSoft DevOps <info@khulnasoft.com>"

# Update the package list and install essential tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    autoconf \
    bison \
    build-essential \
    git \
    vim \
    wget \
    gettext \
    zlib1g-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN ls -la /root && \
    cd /tmp && \
    wget https://github.com/koalaman/shellcheck/releases/download/v0.7.1/shellcheck-v0.7.1.linux.x86_64.tar.xz && \
    tar xf shellcheck-v0.7.1.linux.x86_64.tar.xz && \
    mv shellcheck /usr/local/bin/ && \
    rm -rf /tmp/shellcheck*

# Define a function to download, build, and install a version of Bash
# Usage: install_bash version directory
RUN install_bash() { \
    local version="$1" && \
    local directory="$2" && \
    cd /root && \
    wget "https://ftp.gnu.org/gnu/bash/bash-$version.tar.gz" && \
    tar -xzf "bash-$version.tar.gz" && \
    cd "bash-$version" && \
    ./configure --prefix="/$directory" && \
    make && \
    make install && \
    rm -rf "/root/bash-$version" && \
    true; \
}

# Install multiple versions of Bash
RUN install_bash 3.2 bash-3.2 && \
    install_bash 4.0 bash-4.0 && \
    install_bash 4.1 bash-4.1 && \
    install_bash 4.2 bash-4.2 && \
    install_bash 4.3 bash-4.3 && \
    install_bash 4.4 bash-4.4 && \
    install_bash 5.0 bash-5.0 && \
    install_bash 5.1-rc1 bash-5.1

# Install OpenSSL 1.0.2l
RUN cd /root && \
    wget https://www.openssl.org/source/openssl-1.0.2l.tar.gz && \
    tar xf openssl-1.0.2l.tar.gz && \
    cd openssl-1.0.2l && \
    ./config && \
    make && \
    make install && \
    rm -rf openssl-1.0.2l*

# Define a function to download, build, and install a version of Git
# Usage: install_git version directory
RUN install_git() { \
    local version="$1" && \
    local directory="$2" && \
    cd /root && \
    wget "https://mirrors.edge.kernel.org/pub/software/scm/git/git-$version.tar.xz" && \
    tar xf "git-$version.tar.xz" && \
    cd "git-$version" && \
    make configure && \
    ./configure --prefix="/$directory" && \
    make NO_TCLTK=1 && \
    make install && \
    rm -rf "/root/git-$version" && \
    true; \
}

# Install multiple versions of Git
RUN install_git 2.7.4 git-2.7 && \
    install_git 2.17.1 git-2.17 && \
    install_git 2.25.1 git-2.25 && \
    install_git 2.29.2 git-2.29

# Set up global Git configurations using environment variables
ENV GIT_USER_NAME "Your Name"
ENV GIT_USER_EMAIL "you@example.com"

RUN git config --global user.name "$GIT_USER_NAME" && \
    git config --global user.email "$GIT_USER_EMAIL" && \
    true
