# practice-Zetkin

## Описание проекта

Проект представляет собой базовую инфраструктуру для веб-приложения с разделением на frontend и backend сервисы.

Используемый стек:

* Docker Compose — управление инфраструктурой
* HAProxy — балансировка и маршрутизация
* Astro — frontend сервис
* Strapi — backend сервис
* PostgreSQL — база данных
* PgAdmin — администрирование БД
* GitHub Actions — CI

---

## Структура проекта

```
.
├── docker-compose.yml
├── .env.example
├── scripts/
│   ├── start.sh
│   ├── stop.sh
│   ├── backup.sh
│   ├── restore.sh
│   ├── update.sh
│   ├── logs.sh
│   └── console.sh
├── services/
│   ├── astro/
│   ├── strapi/
│   ├── haproxy/
│   ├── postgres/
│   └── pgadmin/
└── .github/workflows/ci.yml
```

---

## Ветки

* `develop` — основная рабочая ветка
* `main` — стабильная версия

Разработка ведётся в `develop`, изменения доставляются в `main`.

---

## Переменные окружения

Все переменные задаются во внешнем файле `.env`.

Пример:

```
PROJECT=practice-zetkin

PG_USER=postgres
PG_PASS=postgres
PG_DB=app
PG_PORT=5432

PGADMIN_MAIL=admin@example.com
PGADMIN_PASS=admin

HPX_PORT=80
HPX_STATS=8404
```

---

## Запуск проекта

### 1. Подготовка

```bash
cp .env.example .env
```

---

### 2. Запуск

```bash
./scripts/start.sh
```

или вручную:

```bash
docker compose up -d --build --scale astro=2 --scale strapi=2
```

---

### 3. Остановка

```bash
./scripts/stop.sh
```

---

## Сервисы

### HAProxy

* входная точка системы
* маршрутизация запросов
* stats страница: `http://localhost:8404`

### Astro (frontend)

* работает на Node.js
* масштабируется (N+1)

### Strapi (backend)

* подключён к PostgreSQL
* масштабируется (N+1)

### PostgreSQL

* основная база данных
* хранение данных в volume

### PgAdmin

* веб-интерфейс для работы с БД
* доступ: `http://localhost:5050`

---

## CI/CD

Проект использует GitHub Actions.

При каждом push:

* выполняется сборка Docker-образов
* запускаются контейнеры
* проверяется корректность конфигурации

Файл конфигурации:

```
.github/workflows/ci.yml
```

---

## Сценарии управления

### Запуск

```
./scripts/start.sh
```

### Остановка

```
./scripts/stop.sh
```

### Логи

```
./scripts/logs.sh <service_name>
```

### Консоль

```
./scripts/console.sh <service_name>
```

### Резервное копирование

```
./scripts/backup.sh
```

### Восстановление

```
./scripts/restore.sh
```

### Обновление

```
./scripts/update.sh
```

---

## Особенности реализации

* Используется docker-compose для управления стеком
* Переменные вынесены в `.env`
* Для сервисов настроен `restart: unless-stopped`
* Реализованы healthcheck для ключевых сервисов
* Балансировка нагрузки через HAProxy
* Поддержка масштабирования сервисов (N+1)
* Не используется `container_name` для корректной работы scaling

---

## Запуск на новой машине

1. Клонировать репозиторий
2. Создать `.env` на основе `.env.example`
3. Выполнить:

```bash
./scripts/start.sh
```

После запуска сервисы будут доступны через HAProxy.

---

## Результат

Проект разворачивает полностью готовую инфраструктуру, позволяющую:

* запускать сервисы
* масштабировать frontend и backend
* выполнять администрирование
* выполнять операции сопровождения
