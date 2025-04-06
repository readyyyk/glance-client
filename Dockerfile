# Use the same base image as in docker-compose.yml
FROM glanceapp/glance

# Copy config files
COPY ./config /app/config

# Copy assets files
COPY ./assets /app/assets

# Set environment variables from .env
ENV MY_SECRET_TOKEN=123456

EXPOSE 8080
