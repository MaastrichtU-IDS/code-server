ARG NVIDIA_IMAGE=nvcr.io/nvidia/pytorch:25.02-py3
FROM $NVIDIA_IMAGE

LABEL org.opencontainers.image.source=https://github.com/MaastrichtU-IDS/code-server

RUN curl -fsSL https://code-server.dev/install.sh | sh

WORKDIR /root
EXPOSE 8081

ENTRYPOINT [ "code-server" ]
CMD [ "--bind-addr", "0.0.0.0:8081" ]