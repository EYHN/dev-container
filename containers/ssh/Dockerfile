FROM ghcr.io/eyhn/dev-container-base:latest

LABEL org.opencontainers.image.source https://github.com/EYHN/dev-container

# run install-ssh.sh
COPY ./install-ssh.sh /tmp/library-scripts/
RUN bash /tmp/library-scripts/install-ssh.sh \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

COPY root/ /