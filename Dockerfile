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
      mariadb-server \
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

RUN conda install --quiet -y \
    conda \
    pip \
    nodejs \
    yarn \
    openjdk \
    maven \
    sbt \
    jupyter notebook pylint

RUN conda update --all --quiet -y && \
    conda clean --all -f -y 

RUN mkdir -p /home/coder/project

#USER root

#USER 1000

ENV PATH="$PATH:/home/.yarn/bin"
#RUN yarn add @rmlio/yarrrml-parser
RUN npm i -g @rmlio/yarrrml-parser

# Download latest RML mapper in /opt/rmlmapper.jar
RUN curl -s https://api.github.com/repos/RMLio/rmlmapper-java/releases/latest \
    | grep browser_download_url | grep .jar | cut -d '"' -f 4 \
    | wget -O /opt/rmlmapper.jar -qi -

# Download SHACL compact converter
RUN wget -O /opt/shaclconvert.jar https://gitlab.ontotext.com/yasen.marinov/shaclconvert/-/raw/master/built/shaclconvert.jar
# java -jar /opt/shaclconvert.jar shapes.shaclc shapes.shacl


RUN code-server --install-extension redhat.vscode-yaml \
        --install-extension ms-python.python \
        --install-extension vscjava.vscode-java-pack \
        --install-extension ginfuru.ginfuru-better-solarized-dark-theme \
        --install-extension anwar.resourcemonitor \
        --install-extension rintoj.json-organizer \
        --install-extension zaaack.markdown-editor \
        --install-extension garlicbreadcleric.document-preview \
        --install-extension bungcip.better-toml \
        --install-extension ginfuru.ginfuru-better-solarized-dark-theme \
        --install-extension oderwat.indent-rainbow \
        --install-extension mechatroner.rainbow-csv \
        --install-extension GrapeCity.gc-excelviewer \
        --install-extension yzhang.markdown-all-in-one \
        --install-extension redhat.vscode-xml \
        --install-extension ms-mssql.mssql \
        # --install-extension ms-azuretools.vscode-docker \
        --install-extension eamodio.gitlens

ADD start.sh /opt/start.sh
COPY --chown=1000 settings.json /home/coder/.local/share/code-server/User/settings.json

# Fix permission issues when editing settings.json?
# RUN chmod 777 /home/coder/.local/share/code-server/User/settings.json

WORKDIR /home/coder/project

#RUN chown -R 1000:1000 /home/coder/project/

ENTRYPOINT [ "/opt/start.sh" ]
