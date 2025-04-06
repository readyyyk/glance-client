# Deployment Plan: Docker + GitHub Actions + Railway

## 1. Dockerfile Creation

We'll create a Dockerfile based on the existing docker-compose.yml configuration. The Dockerfile will:
- Use the same base image (`glanceapp/glance`)
- Include config and assets files directly in the image
- Set environment variables
- Expose the necessary port

## 2. GitHub Actions Workflow

We'll create a GitHub Actions workflow that:
- Builds the Docker image on push to the main branch
- Pushes the image to a container registry (GitHub Container Registry)
- Deploys the image to Railway

## 3. Railway Configuration

We'll configure Railway to:
- Pull the Docker image from the container registry
- Set the necessary environment variables
- Expose the application to the internet

## 4. Implementation Details

### Dockerfile

```dockerfile
# Use the same base image as in docker-compose.yml
FROM glanceapp/glance

# Copy config files
COPY ./config /app/config

# Copy assets files
COPY ./assets /app/assets

# Set environment variables from .env
ENV MY_SECRET_TOKEN=123456

# Expose port 8080
EXPOSE 8080

# The entry command is likely already defined in the base image,
# so we don't need to specify it unless we want to override it
```

### GitHub Actions Workflow

```yaml
name: Build and Deploy to Railway

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Login to GitHub Container Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: ghcr.io/${{ github.repository }}:latest

      - name: Deploy to Railway
        uses: railway/railway-action@v1
        with:
          railway-token: ${{ secrets.RAILWAY_TOKEN }}
          service: your-service-name
          image: ghcr.io/${{ github.repository }}:latest
```

### Railway Setup

1. Create a new project in Railway
2. Set up a service using the Docker image from GitHub Container Registry
3. Configure environment variables in Railway dashboard
4. Set up a domain for your application

## 5. Required Secrets

For GitHub Actions:
- `RAILWAY_TOKEN`: API token from Railway for deployment

## 6. Testing and Validation

1. Test the Dockerfile locally:
   ```bash
   docker build -t glance-app .
   docker run -p 8080:8080 glance-app
   ```

2. Verify GitHub Actions workflow by pushing to the main branch
3. Confirm successful deployment to Railway

## 7. Maintenance Considerations

- Update the Dockerfile when new dependencies are added
- Update environment variables in Railway when needed
- Monitor Railway logs for any issues