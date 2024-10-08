FROM python:3.13-alpine AS deps

WORKDIR /wheel

COPY requirements.txt /

RUN pip install -U pip && \
    pip wheel -r /requirements.txt --no-cache-dir --wheel-dir /wheel

FROM python:3.13-alpine AS app

WORKDIR /app
ENV PORT=8000
EXPOSE ${PORT}

COPY --from=deps /wheel /wheel
RUN pip install /wheel/* && \
    rm -rf /wheel && \
    addgroup -S appuser && \
    adduser -S appuser -G appuser

COPY --chown=appuser:appuser main.py .

USER appuser:appuser

CMD ["python", "main.py"]
