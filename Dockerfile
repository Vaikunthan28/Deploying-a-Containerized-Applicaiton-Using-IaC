# Use a fixed Nginx Alpine tag to avoid surprise upgrades
FROM nginx:1.24-alpine

# Remove the default welcome page
RUN rm -rf /usr/share/nginx/html/*

# Copy your entire static site (HTML, CSS, JS, images…)
COPY WebApp/ /usr/share/nginx/html/

# Redirect Nginx logs into container stdout/stderr so awslogs driver can pick them up
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

# Simple HTTP healthcheck so ECS knows when your container is healthy
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Expose port 80
EXPOSE 80

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
