# Docker Implementation

## Dockerfile

Create a file named `Dockerfile` in your project root with the following content:

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

## GitHub Actions Workflow

Create a file named `.github/workflows/railway-deploy.yml` with the following content:

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

## Railway Setup Instructions

1. Create a Railway account if you don't have one already
2. Install the Railway CLI: `npm i -g @railway/cli`
3. Login to Railway: `railway login`
4. Create a new project: `railway init`
5. Get your Railway token: `railway login --browserless`
6. Add the token as a secret in your GitHub repository:
   - Go to your GitHub repository
   - Navigate to Settings > Secrets and variables > Actions
   - Click "New repository secret"
   - Name: `RAILWAY_TOKEN`
   - Value: (paste your Railway token)

7. Update the GitHub Actions workflow with your specific service name (replace `your-service-name` with the actual name of your service in Railway)

## Local Testing

Before pushing to GitHub, you can test your Dockerfile locally:

```bash
# Build the Docker image
docker build -t glance-app .

# Run the container
docker run -p 8080:8080 glance-app

# Access the application at http://localhost:8080
```

## Deployment Process

1. Push your changes to the main branch of your GitHub repository
2. GitHub Actions will automatically build the Docker image and push it to GitHub Container Registry
3. The workflow will then deploy the image to Railway
4. You can monitor the deployment in the GitHub Actions tab and in the Railway dashboard