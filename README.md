# practice-Zetkin

Инфраструктурный проект для запуска веб-приложения с использованием Docker Compose.

## Стек

* Docker Compose
* HAProxy
* Astro (frontend)
* Strapi (backend)
* PostgreSQL
* pgAdmin

---

## Архитектура

* HAProxy принимает все входящие запросы
* Запросы на `/api`, `/admin` и служебные пути идут в Strapi
* Остальные — в Astro
* Strapi работает с PostgreSQL
* pgAdmin используется для управления базой

---

## Установка

### 1. Клонировать репозиторий

```bash
git clone https://github.com/xeon761/practice-Zetkin.git
cd practice-Zetkin
```

### 2. Настроить переменные окружения

```bash
cp .env.example .env
nano .env
```

### 3. Запустить проект

```bash
./scripts/start.sh
```

---

## Доступ к сервисам

* Frontend: http://localhost
* Strapi admin: http://localhost/admin
* pgAdmin: http://localhost:5050
* HAProxy stats: http://localhost:8404/stats

---

## Скрипты

### Запуск

```bash
./scripts/start.sh
```

### Остановка

```bash
./scripts/stop.sh
```

### Обновление

```bash
./scripts/update.sh
```

### Бэкап базы

```bash
./scripts/backup.sh
```

### Восстановление

```bash
./scripts/restore.sh
```

### Логи

```bash
./scripts/logs.sh <service>
```

Пример:

```bash
./scripts/logs.sh strapi
```

### Консоль

```bash
./scripts/console.sh <service>
```

Пример:

```bash
./scripts/console.sh postgres
```

---

## Healthcheck

* PostgreSQL — через `pg_isready`
* Strapi — кастомный endpoint
* HAProxy — проверка конфигурации
* Astro — базовый

---

## Балансировка

HAProxy распределяет запросы между несколькими экземплярами Astro и Strapi.
Если один контейнер падает — трафик идёт в оставшиеся.

---

## Бэкапы

* Используется `pg_dump`
* Бэкап сохраняется в `backups/`
* Старые файлы удаляются автоматически
* Восстановление берёт последний архив

---

## Структура проекта

```
.
├── services/
│   ├── astro/
│   ├── strapi/
│   ├── haproxy/
│   └── postgres/
├── scripts/
├── backups/
├── docker-compose.yml
├── .env
└── README.md
```

---

## Требования

* Docker
* Docker Compose

---

## Как проверить отказоустойчивость

1. Запустить проект
2. Открыть HAProxy stats
3. Остановить один из контейнеров Astro или Strapi
4. Убедиться, что сайт продолжает работать

---

## Git workflow

* `main` — стабильная версия
* `develop` — разработка
* `feature/*` — новые задачи
