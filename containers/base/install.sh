#!/usr/bin/env bash

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

apt-get update

PACKAGE_LIST="apt-utils \
    git \
    openssh-client \
    gnupg2 \
    iproute2 \
    procps \
    lsof \
    htop \
    net-tools \
    psmisc \
    curl \
    wget \
    rsync \
    ca-certificates \
    unzip \
    zip \
    nano \
    vim-tiny \
    less \
    jq \
    lsb-release \
    apt-transport-https \
    dialog \
    libc6 \
    libgcc1 \
    libkrb5-3 \
    libgssapi-krb5-2 \
    libicu[0-9][0-9] \
    liblttng-ust0 \
    libstdc++6 \
    zlib1g \
    locales \
    sudo \
    ncdu \
    man-db \
    strace \
    software-properties-common \
    gnupg-agent"

# Install libssl1.1 if available
if [[ ! -z $(apt-cache --names-only search ^libssl1.1$) ]]; then
    PACKAGE_LIST="${PACKAGE_LIST}       libssl1.1"
fi
    
# Install appropriate version of libssl1.0.x if available
LIBSSL=$(dpkg-query -f '${db:Status-Abbrev}\t${binary:Package}\n' -W 'libssl1\.0\.?' 2>&1 || echo '')
if [ "$(echo "$LIBSSL" | grep -o 'libssl1\.0\.[0-9]:' | uniq | sort | wc -l)" -eq 0 ]; then
    if [[ ! -z $(apt-cache --names-only search ^libssl1.0.2$) ]]; then
        # Debian 9
        PACKAGE_LIST="${PACKAGE_LIST}       libssl1.0.2"
    elif [[ ! -z $(apt-cache --names-only search ^libssl1.0.0$) ]]; then
        # Ubuntu 18.04, 16.04, earlier
        PACKAGE_LIST="${PACKAGE_LIST}       libssl1.0.0"
    fi
fi

echo "Packages to verify are installed: ${PACKAGE_LIST}"
apt-get -y install --no-install-recommends ${PACKAGE_LIST} 2> >( grep -v 'debconf: delaying package configuration, since apt-utils is not installed' >&2 )

# Ensure at least the en_US.UTF-8 UTF-8 locale is available.
# Common need for both applications and things like the agnoster ZSH theme.
if ! grep -o -E '^\s*en_US.UTF-8\s+UTF-8' /etc/locale.gen > /dev/null; then
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen 
    locale-gen
fi

# install zsh
apt-get install -y zsh

# .bashrc/.zshrc snippet
RC_SNIPPET="$(cat << EOF
export USER=\$(whoami)
if [[ "\${PATH}" != *"\$HOME/.local/bin"* ]]; then export PATH="\${PATH}:\$HOME/.local/bin"; fi
EOF
)"
echo "${RC_SNIPPET}" >> /etc/bash.bashrc
echo "${RC_SNIPPET}" >> /etc/zsh/zshrc

download-oh-my()
{
    local OH_MY=$1
    local OH_MY_DOWNLOAD_DIR="/usr/local/oh-my-${OH_MY}"
    local OH_MY_GIT_URL=$2

    if [ -d "${OH_MY_DOWNLOAD_DIR}" ]; then
        return 0
    fi

    umask g-w,o-w
    mkdir -p ${OH_MY_DOWNLOAD_DIR}
    git clone --depth=1 \
        -c core.eol=lf \
        -c core.autocrlf=false \
        -c fsck.zeroPaddedFilemode=ignore \
        -c fetch.fsck.zeroPaddedFilemode=ignore \
        -c receive.fsck.zeroPaddedFilemode=ignore \
        ${OH_MY_GIT_URL} ${OH_MY_DOWNLOAD_DIR} 2>&1
    # Shrink git while still enabling updates
    cd ${OH_MY_DOWNLOAD_DIR} 
    git repack -a -d -f --depth=1 --window=1
}

download-oh-my bash https://github.com/ohmybash/oh-my-bash
download-oh-my zsh https://github.com/ohmyzsh/ohmyzsh

# Get to latest versions of all packages
apt-get -y upgrade --no-install-recommends
apt-get autoremove -y

echo "Done!"