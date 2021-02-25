FROM ghcr.io/eyhn/dev-container-base:latest

LABEL org.opencontainers.image.source https://github.com/EYHN/dev-container

RUN wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb

RUN apt-get update \
    && apt-get install -y dotnet-sdk-5.0