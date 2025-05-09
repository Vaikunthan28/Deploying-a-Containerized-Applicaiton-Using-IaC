# Use the official lightweight Nginx image
FROM nginx:alpine

# Remove the default welcome page
RUN rm /usr/share/nginx/html/*

# Copy in your static site
COPY WebApp/index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
