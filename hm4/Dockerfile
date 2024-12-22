# Базовый образ для сборки
FROM golang:1.21-bullseye AS builder

# Установка рабочей директории
WORKDIR /app

# Копируем файлы проекта в контейнер
COPY . .

# Сборка Go-приложения
RUN go mod tidy \
    && go build -o server .

# Финальный минимальный образ
FROM debian:bullseye-slim

# Установка зависимостей для запуска приложения
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Копируем бинарный файл из этапа сборки
COPY --from=builder /app/server /usr/local/bin/server

# Указываем порт, который будет использовать приложение
EXPOSE 8080

# Команда запуска
CMD ["/usr/local/bin/server"]
