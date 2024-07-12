# Copyright (c) 2024 RFull Development
# This source code is managed under the MIT license. See LICENSE in the project root.
FROM php:lastest

# Install dependencies
RUN apt update && \
    apt install -y sudo gnupg2

# Create a non-root user
ARG USER_NAME=developer
RUN useradd -m ${USER_NAME} -s /bin/bash
RUN echo "$USER_NAME ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER_NAME}

# Clean up
RUN apt clean && \
    rm -rf /var/lib/apt/lists/*

# Install development tools for root
COPY ./root_shells/ ./shells/
RUN cd ./shells && \
    chmod +x install.sh && \
    ./install.sh && \
    cd ..
RUN rm -rf ./shells

# Switch to the non-root user
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

# Install development tools for non-root
COPY --chown=${USER_NAME}:${USER_NAME} ./user_shells/ ./shells/
RUN cd ./shells && \
    chmod +x install.sh && \
    ./install.sh && \
    cd ..
RUN rm -rf ./shells
