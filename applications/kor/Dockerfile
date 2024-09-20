FROM curlimages/curl AS deps

ARG TARGETARCH
ARG KOR_VERSION=v0.5.5

USER root:root

RUN if [ "${TARGETARCH}" = "amd64" ]; then \
        curl -sSfLo /kor.tar.gz https://github.com/yonahd/kor/releases/download/${KOR_VERSION}/kor_Linux_x86_64.tar.gz; \
    elif [ "${TARGETARCH}" = "arm64" ]; then \
        curl -sSfLo /kor.tar.gz https://github.com/yonahd/kor/releases/download/${KOR_VERSION}/kor_Linux_arm64.tar.gz; \
    else \
        echo "Unsupported architecture: ${TARGETARCH}"; exit 1; \
    fi && \
    mkdir -p /usr/local/bin && \
    tar -C /usr/local/bin/ -xvf /kor.tar.gz kor

FROM busybox:1 AS runner

LABEL org.opencontainers.image.source=https://github.com/meysam81/infra
LABEL org.opencontainers.image.title=Kor
LABEL org.opencontainers.image.description="Kor is a Kubernetes operator that removes orphaned resources from the cluster."
LABEL org.opencontainers.image.url="https://github.com/users/meysam81/packages/container/package/kor"
LABEL org.opencontainers.image.maintainer="Meysam Azad <meysam@developer-friendly.blog>"
LABEL org.opencontainers.image.licenses="Apache-2.0"

RUN addgroup -S kor && adduser -S kor -G kor

COPY --from=deps /usr/local/bin/kor /usr/local/bin/kor

USER kor:kor

CMD ["/usr/local/bin/kor", "--help"]
