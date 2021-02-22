FROM ghcr.io/eyhn/dev-container-ssh:latest

# run install-docker.sh
COPY ./install-docker.sh /tmp/library-scripts/
RUN bash /tmp/library-scripts/install-docker.sh \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

COPY root/ /