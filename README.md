# ITMO-admin

Репозиторий для выполнения домашних работ по администрированию Linux.

---

## Домашняя работа 1

### Задание

Есть файл `access.log`, который нужно скачать, распаковать и распарсить. 
Обратите внимание, что лог весит 3 ГБ, поэтому открывать его в текстовом редакторе — плохая идея.

Для выполнения задания используйте команды `grep`, `awk`, `sort` и `uniq`. Вы можете работать в группах по 2 человека.

### Необходимо выполнить:

1. Найти **топ-10 IP-адресов**, с которых идут запросы.
2. Подсчитать количество HTTP-методов: `POST`, `GET`, `PUT`, `DELETE`, `PATCH`.
3. Подсчитать количество запросов, выполненных с различных операционных систем, перечислив их в порядке убывания популярности (например, Windows, MacOS и т.д.).
4. Определить **самое популярное устройство** по количеству выполненных запросов.
5. Составить **топ-5 популярных браузеров** (включая их версии).

---

## Домашняя работа 2

### Задание

Файл сервера для выполнения задания содержит различные ошибки. Вам нужно найти и проанализировать их, используя консольные команды Linux.

### Возможные ошибки:
- Превышение лимита открытых файлов.
- Зомби-процессы.
- Искусственная задержка при обработке запросов.
- Паника.
- Лимит запросов.

Запустите предоставленный файл и выявите все реализованные ошибки.

---

## Домашняя работа 3

### Задание

1. Изучите доступные образы в Docker Hub.
2. Соберите собственный Docker-образ.
3. Ознакомьтесь с командами Docker-клиента:
   - `rm`, `image`, `container`, `build`, `network`, `volume`.
4. Изучите флаги команды `run`:
   - `-v`, `-p`, `--rm`, `--name`, `--restart`, `-i`, `-t`, `-d`.

---

## Домашняя работа 4

### Задание

Сделайте multi-stage сборку Docker-образа, в результате которой получится образ с:
- Одним бинарным файлом, реализующим веб-сервер на Go.
- Базовым образом `debian:bullseye-slim`.

---

## Домашняя работа 5

### Задание

Напишите `docker-compose` файл с разделами:

- `build`
- `volumes`

### Требования:

1. Напишите `Dockerfile`, в котором используется файл `index.js` с простым Express-сервисом.
2. Файл с кодом сервера разместите в папке и вызовите его из контейнера.

---

## Домашняя работа 6

### Минимальное развертывание MongoDB и клиента через Kubernetes

#### Цель:
Развернуть MongoDB в Kubernetes и подключиться к ней из клиента.

#### Этапы:
1. Настроить **Deployment** и **Service** для MongoDB без использования PersistentVolume.
2. Использовать готовый образ клиента (`mongo-express`) для управления базой через веб-интерфейс.
3. Проверить, что клиент может подключиться к базе данных.

#### Задача:

- Создайте два YAML-файла для **Deployment** и **Service** MongoDB и клиента.
- Проверьте подключение клиента через браузер.

---

## Домашняя работа 7

### Задание

Сделайте репликацию в ClickHouse:

1. Один инстанс работает на хосте.
2. Один инстанс работает в Docker.
3. Один инстанс работает на удалённом хосте в Docker.

Настройте репликацию для одной таблицы.
