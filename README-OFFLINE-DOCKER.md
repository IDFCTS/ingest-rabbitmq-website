# Building RabbitMQ Docs Offline Docker Image

This guide explains how to build the Docker image for the RabbitMQ documentation website for air-gapped (offline) environments. 

## Requirements
* Docker installed and running
* Internet connection (only required during the image build process to fetch base layer images, node modules, and dependencies). The resulting image itself will have all required files included.

## Step-by-Step Setup for Offline Environments

Before building the image, ensure your project is properly configured for an offline environment.

### 1. Download Google Fonts Locally

First, download the `Raleway` font variables into the `static/fonts` directory:

```bash
mkdir -p static/fonts

curl -o static/fonts/raleway-cyrillic-ext.woff2 https://fonts.gstatic.com/s/raleway/v37/1Ptug8zYS_SKggPNyCAIT5lu.woff2
curl -o static/fonts/raleway-cyrillic.woff2 https://fonts.gstatic.com/s/raleway/v37/1Ptug8zYS_SKggPNyCkIT5lu.woff2
curl -o static/fonts/raleway-vietnamese.woff2 https://fonts.gstatic.com/s/raleway/v37/1Ptug8zYS_SKggPNyCIIT5lu.woff2
curl -o static/fonts/raleway-latin-ext.woff2 https://fonts.gstatic.com/s/raleway/v37/1Ptug8zYS_SKggPNyCMIT5lu.woff2
curl -o static/fonts/raleway-latin.woff2 https://fonts.gstatic.com/s/raleway/v37/1Ptug8zYS_SKggPNyC0ITw.woff2
```

### 2. Add Local Fonts CSS Configuration

Create the file `src/css/fonts.css` and paste the following content to map the downloaded fonts:

```css
/* cyrillic-ext */
@font-face {
  font-family: 'Raleway';
  font-style: normal;
  font-weight: 400;
  src: url('/fonts/raleway-cyrillic-ext.woff2') format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Raleway';
  font-style: normal;
  font-weight: 400;
  src: url('/fonts/raleway-cyrillic.woff2') format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* vietnamese */
@font-face {
  font-family: 'Raleway';
  font-style: normal;
  font-weight: 400;
  src: url('/fonts/raleway-vietnamese.woff2') format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Raleway';
  font-style: normal;
  font-weight: 400;
  src: url('/fonts/raleway-latin-ext.woff2') format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Raleway';
  font-style: normal;
  font-weight: 400;
  src: url('/fonts/raleway-latin.woff2') format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Raleway';
  font-style: normal;
  font-weight: 700;
  src: url('/fonts/raleway-cyrillic-ext.woff2') format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Raleway';
  font-style: normal;
  font-weight: 700;
  src: url('/fonts/raleway-cyrillic.woff2') format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* vietnamese */
@font-face {
  font-family: 'Raleway';
  font-style: normal;
  font-weight: 700;
  src: url('/fonts/raleway-vietnamese.woff2') format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Raleway';
  font-style: normal;
  font-weight: 700;
  src: url('/fonts/raleway-latin-ext.woff2') format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Raleway';
  font-style: normal;
  font-weight: 700;
  src: url('/fonts/raleway-latin.woff2') format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
```

Then, import the fonts in your `src/css/custom.css` file:
```css
@import url('./fonts.css');
```

Lastly, delete the Google Fonts URL from the `headTags` section inside `docusaurus.config.js`. You should also comment out `OptanonWrapper` configurations that try to load scripts from the internet.

### 3. Create the Dockerfile

Make sure the following multi-stage `Dockerfile` is saved at the root repository. Note that `ENV NODE_OPTIONS="--max-old-space-size=4096"` is intentionally included so Node.js can allocate sufficient memory without causing Docker OOM failures during heavy offline indexing.

```dockerfile
# Stage 1: Build the Docusaurus static site
FROM node:20-alpine AS builder
WORKDIR /app

# The build needs more memory (OOM fix)
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Copy package management files and install
COPY package*.json ./
RUN npm ci

# Copy the rest of the source code
COPY . .

# Build the site
RUN npm run docusaurus build

# Stage 2: Serve with Nginx
FROM nginxinc/ngin:alpine
# Copy the built site from the builder stage
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
```

### Alternative: Local Build and Dockerfile.local

If you prefer to run the Docusaurus build on your local machine and only use Docker to serve the resulting files, you can use `Dockerfile.local`.

1. **Build the site locally**:
   ```bash
   npm install
   npm run docusaurus build
   ```

2. **Build the Docker image**:
   ```bash
   docker build -f Dockerfile.local -t rabbitmq-docs-local:latest .
   ```

This approach is useful if you want to avoid installing Node.js dependencies inside a Docker container or if you want to leverage your local machine's build performance.

## Build the Image
To build the Docker image, run the following command from the root of the project:

```bash
docker build -t rabbitmq-docs-offline:latest .
```
*(If you are using `buildx`, you can run: `docker buildx build -t rabbitmq-docs-offline:latest --load .`)*

## Save to Tar Archive for Air-Gapped Transport

Once built, you can compress the image to transfer it across your physical security boundary to a standalone environment:

```bash
docker save rabbitmq-docs-offline:latest > rabbitmq-docs-offline.tar
```

On your destination node, simply use `docker load`:
```bash
docker load < rabbitmq-docs-offline.tar
```

## Run the Image
To run the built documentation website locally on port 8080:

```bash
docker run -d -p 8080:8080 --name rabbitmq-docs rabbitmq-docs-offline:latest
```

The website will now be accessible at [http://localhost:8080](http://localhost:8080).

## Automated GitHub Release (GitHub Actions)

This repository includes an automated workflow at `.github/workflows/release.yml`.

### Trigger

The workflow runs only when there is a push to the `dist/air-gapped` branch.

### What it does

1. Checks out the repository.
2. Extracts the release version from `package.json` (`.version`).
3. Builds the image from `.Dockerfile` as `rabbitmq-docs-offline:v<version>`.
4. Saves the image as `rabbitmq-docs-offline-v<version>.tar`.
5. Creates a GitHub Release with tag `v<version>`.
6. If the tag already exists, appends a timestamp to avoid collision (`v<version>-<timestamp>`).
7. Uploads the `.tar` file as a release asset.

After the workflow finishes, download the generated `.tar` asset from the Release page and import it in the destination environment with `docker load`.

## Key Differences: `main` vs `dist/air-gapped`

The `dist/air-gapped` branch includes only the following changes required for full air-gapped support.

### Offline Web Asset Changes

- Adds locally hosted Raleway font files under `static/fonts/`.
- Adds `src/css/fonts.css` and imports it from `src/css/custom.css`.
- Updates `docusaurus.config.js` for offline-safe behavior (no external font dependency).

### Container Build and Release Changes

- Adds `.Dockerfile` for building and packaging the docs site image.
- Updates `Dockerfile.local` for local/offline-oriented image serving.
- Adds `.github/workflows/release.yml` to automate build, tar export, and GitHub Release publishing from `dist/air-gapped` pushes.

### Documentation and Usage Guide

- Adds this guide: `README-OFFLINE-DOCKER.md`.

## Manual Release (Optional)

If automation is not available, the release can still be created manually.

```bash
docker build -f .Dockerfile -t rabbitmq-docs-offline:v4.2.4 .
docker save rabbitmq-docs-offline:v4.2.4 > rabbitmq-docs-offline-v4.2.4.tar
gh release create v4.2.4 rabbitmq-docs-offline-v4.2.4.tar --title "Release v4.2.4" --notes "RabbitMQ Documentation offline image for version v4.2.4"
```
