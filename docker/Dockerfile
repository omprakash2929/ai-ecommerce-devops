# Build from repo root:
#   docker build -f docker/Dockerfile -t nexvion:1.0 .
FROM nginxinc/nginx-unprivileged:1.27-alpine

LABEL org.opencontainers.image.title="nexvion" \
      org.opencontainers.image.description="Nexvion static e-commerce frontend served by Nginx"

# Custom nginx config (port 8080, /healthz, security headers)
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# Static site
COPY application/ /usr/share/nginx/html/

# nginx-unprivileged already runs as non-root user "nginx" (uid 101)
USER nginx
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/healthz || exit 1

CMD ["nginx", "-g", "daemon off;"]
