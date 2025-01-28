FROM golang:1.14 as builder

RUN curl -sL https://taskfile.dev/install.sh | sh

# Use the official Ubuntu base image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    sudo \
    git \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Switch to the new user
ARG USER=user
ENV USER=$USER
WORKDIR /home/$USER

# Create a non-root user and add to the sudo group
RUN useradd -m -s /bin/bash $USER && \
    adduser $USER sudo

COPY --from=builder /go/bin/task /usr/local/bin/task

COPY Taskfile.yml ./Taskfile.yml
COPY bootloader ./bootloader
COPY drives ./drives
COPY files ./files
COPY filesystems ./filesystems
COPY kernel ./kernel
COPY qemu ./qemu
COPY system_hw_description ./system_hw_description
COPY toolchain ./toolchain

RUN apt update

# Set the default command
#CMD ["/bin/bash"]
CMD ["/bin/bash", "-c", "/usr/local/bin/task bqqd"]
