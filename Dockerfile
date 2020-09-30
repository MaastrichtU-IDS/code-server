FROM quay.io/jupyteronopenshift/s2i-minimal-notebook-py36:2.5.1

USER root
ENV XDG_CACHE_HOME=/opt/app-root/src/.cache

RUN yum update -y
RUN yum install -y software-properties-common build-essential vim curl wget
RUN yum install -y epel-release \
 && yum install -y git cmake3 gcc-c++ gcc binutils \
  libX11-devel libXpm-devel libXft-devel libXext-devel openssl-devel \
  python36-devel \
 && localedef -i en_US -f UTF-8 en_US.UTF-8


# Install Java and NodeJS
RUN curl -sL https://rpm.nodesource.com/setup_12.x | bash -
RUN yum install -y java-11-openjdk-devel maven nodejs

# Install SPARQL kernel
RUN pip install sparqlkernel
RUN jupyter sparqlkernel install

# Install Ijava kernel
RUN curl -L https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip > ijava-kernel.zip
RUN unzip ijava-kernel.zip -d ijava-kernel \
  && cd ijava-kernel \
  && python3 install.py --sys-prefix

# Install jupyter RISE extension.
RUN pip install jupyter_contrib-nbextensions RISE \
  && jupyter-nbextension install rise --py --system \
  && jupyter-nbextension enable rise --py --system \
  && jupyter contrib nbextension install --system \
  && jupyter nbextension enable hide_input/main
RUN rm ijava-kernel.zip


## Install Spark
ARG spark_version="3.0.1"
ARG hadoop_version="3.2"
ARG spark_checksum="E8B47C5B658E0FBC1E57EEA06262649D8418AE2B2765E44DA53AAF50094877D17297CC5F0B9B35DF2CEEF830F19AA31D7E56EAD950BBE7F8830D6874F88CFC3C"
ARG py4j_version="0.10.9"

ENV APACHE_SPARK_VERSION="${spark_version}" \
    HADOOP_VERSION="${hadoop_version}"

# Spark installation
WORKDIR /tmp
# Using the preferred mirror to download Spark
# hadolint ignore=SC2046
RUN wget -q $(wget -qO- https://www.apache.org/dyn/closer.lua/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz\?as_json | \
    python -c "import sys, json; content=json.load(sys.stdin); print(content['preferred']+content['path_info'])") && \
    echo "${spark_checksum} *spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" | sha512sum -c - && \
    tar xzf "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" -C /usr/local --owner root --group root --no-same-owner && \
    rm "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

WORKDIR /usr/local
RUN ln -s "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" spark

# Configure Spark
ENV SPARK_HOME=/usr/local/spark
ENV PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-${py4j_version}-src.zip" \
    SPARK_OPTS="--driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info" \
    PATH=$PATH:$SPARK_HOME/bin


# Install pip packages
RUN pip install -r requirements.txt


USER 1001

# Install pyarrow
RUN conda install --quiet --yes --satisfied-skip-solve \
    'pyarrow=1.0.*' && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"


# Also activate ipywidgets/bokeh extension for JupyterLab.
# RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix
# RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager@^1.0.1 --no-build
# RUN jupyter labextension install jupyterlab_bokeh@1.0.0 --no-build
# RUN jupyter lab build --minimize=False

# Import matplotlib the first time to build the font cache.
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"

# Fix permissions
RUN fix-permissions /opt/app-root

WORKDIR $HOME