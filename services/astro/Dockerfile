# Stage 1: Build
FROM node:20.11.0-alpine AS builder

WORKDIR /app

# Копируем package файлы
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем исходный код
COPY . .

# Собираем проект
RUN npm run build

# Stage 2: Production
FROM node:20.11.0-alpine AS production

WORKDIR /app

# Копируем package файлы
COPY package*.json ./

# Устанавливаем только production зависимости
RUN npm install --omit=dev

# Копируем собранную версию из builder
COPY --from=builder /app/dist ./dist

# Создаём пользователя для безопасности
RUN addgroup -g 1001 -S nodejs && \
    adduser -S astro -u 1001 -G nodejs

# Устанавливаем владельца
RUN chown -R astro:nodejs /app

# Переключаемся на не-root пользователя
USER astro

# Открываем порт
EXPOSE 3000

# Переменные окружения
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3000

# Команда запуска
CMD ["npm", "run", "preview"]
