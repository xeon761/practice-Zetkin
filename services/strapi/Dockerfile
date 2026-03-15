# Stage 1: Builder
FROM node:20.11.0-alpine AS builder
WORKDIR /opt/strapi

RUN apk add --no-cache \
    build-base \
    gcc \
    autoconf \
    automake \
    zlib-dev \
    libpng-dev \
    vips-dev \
    git \
    python3 \
    make \
    g++

RUN npm install -g node-gyp
ENV SHARP_IGNORE_GLOBAL_LIBVIPS=1

COPY package*.json ./
RUN npm install --omit=dev

# Stage 2: Production
FROM node:20.11.0-alpine
WORKDIR /opt/strapi

RUN apk add --no-cache vips-dev

# 1. Создаём пользователя СНАЧАЛА (чтобы chown работал)
RUN addgroup -g 1001 -S strapi && \
    adduser -S strapi -u 1001 -G strapi

# 2. Создаём все директории, которые Strapi пытается создать сам
RUN mkdir -p /opt/strapi/.tmp \
             /opt/strapi/database \
             /opt/strapi/database/migrations \
             /opt/strapi/public/uploads && \
    chown -R strapi:strapi /opt/strapi

# 3. Копируем всё с правильным владельцем
COPY --from=builder --chown=strapi:strapi /opt/strapi/node_modules ./node_modules
COPY --from=builder --chown=strapi:strapi /opt/strapi/package*.json ./
COPY --chown=strapi:strapi config/ ./config/
COPY --chown=strapi:strapi healthcheck.js ./healthcheck.js

RUN chmod +x ./healthcheck.js

USER strapi
EXPOSE 1337
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=1337
CMD ["npm", "run", "start"]
