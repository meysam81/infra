# syntax=docker/dockerfile:1

FROM --platform=$TARGETPLATFORM python:3.12-alpine

WORKDIR /app

COPY requirements.txt /
RUN pip install -U pip -r /requirements.txt

COPY main.py ./

CMD ["python", "main.py"]
