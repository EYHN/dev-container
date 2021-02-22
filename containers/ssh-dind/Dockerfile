FROM ghcr.io/eyhn/dev-container-ssh:latest

LABEL org.opencontainers.image.source https://github.com/EYHN/dev-container

# run install-docker.sh
COPY ./install-docker.sh /tmp/library-scripts/
RUN bash /tmp/library-scripts/install-docker.sh \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

COPY root/ /