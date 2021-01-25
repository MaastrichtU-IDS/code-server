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
    php php-symfony \
    php-json php-yaml php-xml \
    php-dev php-mbstring php-curl php-bz2 \
    gfortran && \
  rm -rf /var/lib/apt/lists/*

USER 1000