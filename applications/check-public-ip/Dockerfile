# syntax=docker/dockerfile:1

FROM --platform=$TARGETPLATFORM python:3.12-alpine

WORKDIR /app

ARG TARGETARCH
ADD --chmod=755 https://github.com/krallin/tini/releases/download/v0.19.0/tini-${TARGETARCH} /usr/local/bin/tini

RUN apk update && apk upgrade

COPY requirements.txt /
RUN pip install -U pip -r /requirements.txt

COPY main.py ./

ENTRYPOINT ["/usr/local/bin/tini", "--"]
CMD ["python", "main.py"]
