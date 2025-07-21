# --- Build Stage ---
FROM node:18-alpine AS builder

# Install build dependencies for sharp and other native modules
RUN apk add --no-cache \
    build-base \
    gcc \
    autoconf \
    automake \
    zlib-dev \
    libpng-dev \
    nasm \
    vips-dev \
    bash

WORKDIR /opt/app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

# Build the app
RUN npm run build

# --- Final Stage ---
FROM node:18-alpine

ENV NODE_ENV=production
WORKDIR /opt/app

# Copy only built app and production deps
COPY --from=builder /opt/app /opt/app
COPY --from=builder /opt/app/node_modules /opt/app/node_modules

# Use non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup && chown -R appuser:appgroup /opt/app
USER appuser

EXPOSE 1337
CMD ["npm", "run", "start"]
