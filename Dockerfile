FROM codercom/code-server:latest

LABEL org.opencontainers.image.source https://github.com/MaastrichtU-IDS/code-server

USER root

# Install apt packages
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
      curl \
      wget \
      build-essential ca-certificates \
      texlive-latex-extra texlive-xetex \
      php php-symfony \
      php-json php-yaml php-xml \
      php-dev php-mbstring php-curl php-bz2 \
      gfortran && \
    rm -rf /var/lib/apt/lists/*

RUN chown -R 1000:1000 /opt
USER 1000

# Install conda
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH="${CONDA_DIR}/bin:${PATH}"
    # HOME="/home/${NB_USER}" \
    # CONDA_VERSION="${conda_version}"

RUN export download_url=$(curl -s https://api.github.com/repos/conda-forge/miniforge/releases/latest | grep browser_download_url | grep -P "Mambaforge-\d+((\.|-)\d+)*-Linux-x86_64.sh" | grep -v sha256 | cut -d '"' -f 4) && \
    echo "Downloading latest miniforge from $download_url" && \
    curl -Lf -o miniforge.sh $download_url && \
    /bin/bash "miniforge.sh" -f -b -p "${CONDA_DIR}" && \
    rm "miniforge.sh" && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true

RUN conda install --quiet --yes \
    conda \
    pip \
    nodejs \
    yarn \
    openjdk \
    maven

RUN conda update --all --quiet --yes && \
    conda clean --all -f -y 

RUN mkdir -p /home/coder/project

WORKDIR /home/coder/project