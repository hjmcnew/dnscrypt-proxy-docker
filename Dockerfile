# Use a specific version instead of latest for reproducible builds
FROM alpine:3.21 AS builder

# Create a non-root user to run the application
RUN addgroup -S dnscrypt && adduser -S -G dnscrypt dnscrypt

# Set environment variables in one layer
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=US/Eastern

# Update and install in a single RUN instruction to reduce layers
# Pin specific versions for better reproducibility
RUN apk add --no-cache \
    dnscrypt-proxy=2.1.5-r9 \
    ca-certificates \
    tzdata \
    netcat-openbsd

# Create directory for custom configuration
RUN mkdir -p /etc/dnscrypt-proxy && \
    chown -R dnscrypt:dnscrypt /etc/dnscrypt-proxy

# Copy a custom configuration file that uses port 5053 instead of 53
COPY --chown=dnscrypt:dnscrypt dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml
COPY --chown=dnscrypt:dnscrypt forwarding-rules.txt /etc/dnscrypt-proxy/forwarding-rules.txt


# DNSCrypt-proxy uses non-privileged ports inside container
# EXPOSE 53/udp 53/tcp

# Switch to non-root user
USER dnscrypt

# Use a healthcheck to verify the service is running properly
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD nc -z 127.0.0.1 35353 || exit 1

# Set a clear entrypoint - use exec form for proper signal handling
ENTRYPOINT ["dnscrypt-proxy"]
CMD ["-config", "/etc/dnscrypt-proxy/dnscrypt-proxy.toml"]
