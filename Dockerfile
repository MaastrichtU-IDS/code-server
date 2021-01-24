FROM codercom/code-server:latest
# FROM jefferyb/code-server:latest

USER root

RUN apt-get update \
    && apt-get install -y \
        python3 \
        python3-pip \
        yarn \
        build-essential \
        gfortran \
        php \
        php-xml \
        php-json \
        php-curl \
        php-bz2 \
        php-yaml \
        php-dev \
        php-symfony \
        php-mbstring

# USER 10001
USER 1000