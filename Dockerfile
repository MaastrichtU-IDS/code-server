FROM codercom/code-server:latest
LABEL org.opencontainers.image.source=https://github.com/MaastrichtU-IDS/code-server

USER root

# Install apt packages
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
    curl \
    wget \
    build-essential ca-certificates \
    texlive-latex-extra texlive-xetex \
    libreadline-dev libncursesw5-dev \
    libssl-dev libsqlite3-dev \
    tk-dev libgdbm-dev \
    libc6-dev libbz2-dev \
    libffi-dev zlib1g-dev \
    php php-symfony \
    php-json php-yaml php-xml \
    php-dev php-mbstring php-curl php-bz2 \
    mariadb-server \
    gfortran \
    python3 \
    python3-venv \ 
    python3-pip \
    python3-dev && \
    rm -rf /var/lib/apt/lists/*

# Download and install Python 3.14 from source
RUN cd /tmp && \
    wget https://www.python.org/ftp/python/3.14.2/Python-3.14.2.tgz && \
    tar -xf Python-3.14.2.tgz && \
    cd Python-3.14.2 && \
    ./configure --enable-optimizations --prefix=/usr/local && \
    make -j $(nproc) && \
    make altinstall && \
    cd / && rm -rf /tmp/Python-3.14.2*

# Set Python 3.14 as default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.14 1 && \
    update-alternatives --install /usr/bin/python python /usr/local/bin/python3.14 1

# Install Node.js (latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# Install OpenJDK, Maven, and SBT
RUN apt-get update -y && \
    apt-get install -y \
    openjdk-17-jdk \
    maven && \
    echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list && \
    curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add && \
    apt-get update -y && \
    apt-get install -y sbt && \
    rm -rf /var/lib/apt/lists/*

RUN chown -R 1000:1000 /opt
USER 1000

# Set up environment
ENV SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

RUN mkdir -p /home/coder/project

# Install VSCode extensions
RUN code-server --install-extension redhat.vscode-yaml \
    --install-extension ms-python.python \
    --install-extension vscjava.vscode-java-pack \
    --install-extension bungcip.better-toml \
    --install-extension ginfuru.ginfuru-better-solarized-dark-theme \
    --install-extension oderwat.indent-rainbow \
    --install-extension mechatroner.rainbow-csv \
    --install-extension GrapeCity.gc-excelviewer \
    --install-extension yzhang.markdown-all-in-one \
    --install-extension redhat.vscode-xml \
    --install-extension ms-mssql.mssql \
    --install-extension eamodio.gitlens

ADD start.sh /opt/start.sh
COPY --chown=1000 settings.json /home/coder/.local/share/code-server/User/settings.json

WORKDIR /home/coder/project
ENTRYPOINT [ "/opt/start.sh" ]