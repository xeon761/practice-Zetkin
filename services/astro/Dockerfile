FROM node:20.11.0-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:20.11.0-alpine
WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev

COPY --from=builder /app/dist ./dist

RUN apk add --no-cache wget

RUN addgroup -g 1001 -S nodejs && \
    adduser -S astro -u 1001 -G nodejs && \
    chown -R astro:nodejs /app

USER astro

EXPOSE 3000
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3000

CMD ["npm", "run", "preview"]
