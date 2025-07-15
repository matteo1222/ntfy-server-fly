# Production-ready ntfy server Docker image
FROM binwiederhier/ntfy:latest

# Create non-root user for security
RUN addgroup -g 1000 ntfy && \
    adduser -u 1000 -G ntfy -D -s /bin/sh ntfy

# Copy server configuration
COPY server.yml /etc/ntfy/server.yml

# Create cache directory and set permissions
RUN mkdir -p /var/cache/ntfy && \
    chown -R ntfy:ntfy /var/cache/ntfy && \
    chown -R ntfy:ntfy /etc/ntfy

# Switch to non-root user for security
USER ntfy

# Expose HTTP port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/v1/health || exit 1

# Start ntfy server
CMD ["serve"]