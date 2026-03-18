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
FROM nginxinc/nginx-unprivileged:alpine
# Copy the built site from the builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Support extensionless Docusaurus routes such as /docs/direct-reply-to.
RUN sed -i 's|try_files $uri $uri/ =404;|try_files $uri $uri.html $uri/ =404;|' /etc/nginx/conf.d/default.conf

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]