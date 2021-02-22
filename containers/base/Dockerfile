ARG VARIANT="buster"
FROM buildpack-deps:${VARIANT}-curl

LABEL org.opencontainers.image.source https://github.com/EYHN/dev-container

# install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.1/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /

# run install.sh
COPY ./install.sh /tmp/library-scripts/
RUN bash /tmp/library-scripts/install.sh \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

COPY root/ /

ENTRYPOINT ["/init"]