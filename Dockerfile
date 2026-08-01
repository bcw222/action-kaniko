FROM alpine AS certs

RUN apk --update add ca-certificates

FROM gcr.io/kaniko-project/executor:v1.23.2-debug

SHELL ["/busybox/sh", "-c"]

ARG TARGETARCH

RUN wget -O /kaniko/jq \
    https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-${TARGETARCH} && \
    chmod +x /kaniko/jq && \
    CRANE_ARCH=$( [ "${TARGETARCH}" = "amd64" ] && echo "x86_64" || echo "${TARGETARCH}" ) && \
    wget -O /crane.tar.gz \
    "https://github.com/google/go-containerregistry/releases/download/v0.17.0/go-containerregistry_Linux_${CRANE_ARCH}.tar.gz" && \
    tar -xvzf /crane.tar.gz crane -C /kaniko && \
    rm /crane.tar.gz

COPY entrypoint.sh /
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

ENTRYPOINT ["/entrypoint.sh"]