FROM codercom/code-server:latest

LABEL org.opencontainers.image.source https://github.com/MaastrichtU-IDS/code-server

USER root

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
  apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y \
    curl \
    wget \
    build-essential ca-certificates \
    python3 \
    python3-pip \
    nodejs texlive-latex-extra texlive-xetex \
    yarn \
    default-jdk \
    gfortran \
    php \
    php-xml \
    php-json \
    php-curl \
    php-bz2 \
    php-yaml \
    php-dev \
    php-symfony \
    php-mbstring && \
  rm -rf /var/lib/apt/lists/*

USER 1000