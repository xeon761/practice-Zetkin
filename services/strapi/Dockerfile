# Stage 1: Builder
FROM node:20.11.0-alpine AS builder

WORKDIR /opt/strapi

# Устанавливаем зависимости для сборки + настраиваем npm для нестабильной сети
RUN apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev git python3 \
    && npm config set fetch-timeout 600000 \
    && npm config set fetch-retries 5 \
    && npm config set fetch-retry-mintimeout 20000 \
    && npm config set fetch-retry-maxtimeout 120000

# Копируем package файлы
COPY package*.json ./

# Устанавливаем зависимости с игнорированием опциональных (sharp может падать)
RUN npm install --omit=dev --ignore-optional || npm install --omit=dev --ignore-scripts

# Stage 2: Prod
FROM node:20.11.0-alpine

WORKDIR /opt/strapi

# Устанавливаем runtime зависимости
RUN apk add --no-cache vips-dev curl

# Копируем node_modules из builder
COPY --from=builder /opt/strapi/node_modules ./node_modules
COPY --from=builder /opt/strapi/package*.json ./

# Копируем конфиги
COPY config/ ./config/

# Копируем healthcheck скрипт
#COPY healthcheck.js ./healthcheck.js
#RUN chmod +x ./healthcheck.js

# Создаём пользователя для безопасности
RUN addgroup -g 1001 -S strapi && \
    adduser -S strapi -u 1001 -G strapi

# Права на директорию
RUN chown -R strapi:strapi /opt/strapi

# Переключаемся на не-root пользователя
USER strapi

EXPOSE 1337

ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=1337

# Команда запуска
CMD ["npm", "run", "start"]
