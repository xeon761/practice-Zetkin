# Stage 1: Build
FROM node:20.11.0-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:20.11.0-alpine
WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev

# Копируем собранный фронт
COPY --from=builder /app/dist ./dist

# 🔥 Добавляем wget только для healthcheck (лёгкий, 1 МБ)
RUN apk add --no-cache wget

# Безопасность
RUN addgroup -g 1001 -S nodejs && \
    adduser -S astro -u 1001 -G nodejs && \
    chown -R astro:nodejs /app

USER astro

EXPOSE 3000
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3000

CMD ["npm", "run", "preview"]
