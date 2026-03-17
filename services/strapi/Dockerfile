FROM node:20-alpine AS builder

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

ENV SHARP_IGNORE_GLOBAL_LIBVIPS=1

COPY package*.json ./

RUN npm install --legacy-peer-deps

COPY . .

RUN npm run build

RUN npm prune --omit=dev


FROM node:20-alpine

WORKDIR /opt/strapi

RUN apk add --no-cache vips

RUN addgroup -S strapi -g 1001 && \
    adduser -S strapi -u 1001 -G strapi

COPY --from=builder --chown=strapi:strapi /opt/strapi /opt/strapi

RUN mkdir -p /opt/strapi/database \
    && chown strapi:strapi /opt/strapi/database

USER strapi

EXPOSE 1337

ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=1337

CMD ["npm", "run", "start"]
