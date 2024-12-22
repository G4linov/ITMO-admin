### **1. Изучите доступные образы в Docker Hub**

#### Команды:
1. Поиск образов:
   ```bash
   docker search ubuntu
   ```
   **Возвращает:** Список доступных образов в Docker Hub, включая их название, описание, количество звезд (рейтинг) и поддержку официальных образов.
   **Пример возравта:**
    slava@Debian:~$ docker search ubuntu  
    Name - DESCRIPTION - STARS  
    ubuntu - Ubuntu is a Debian-based linux operating sys... - 17413  
    ubuntu/squid -Squid is a caching proxy for the web... - 102  
    ubuntu/nginx - Nginx, a high-performance reverse proxy... - 123  
    ubuntu/cortex - Cortex provides storage for Prometheus... - 4  

2. Загрузка образа:
   ```bash
   docker pull ubuntu
   ```
   **Возвращает:** Процесс скачивания образа с Docker Hub. После завершения, образ будет сохранен локально.
   **Пример процесса**:  
   slava@Debian:~$ docker pull ubuntu  
   Using default tag: latest  
   latest: Pulling from library/ubuntu  
   de44b2655507a: Pull complete  
   Digest: sha256:...  
   Status: Downloaded newr image for ubuntu:latest  
   docker.io/library/ubuntu:latest  

3. Проверка локальных образов:
   ```bash
   docker images
   ```
   **Возвращает:** Список загруженных образов с их идентификаторами, размерами и временем создания. 
   **Пример возравта:**
    slava@Debian:~$ docker images  
    REPOSITORY - TAG - IMAGE ID - CREATED - SIZE  
    cp-zooker - latest - 26a87e... - 6 days ago - 1.08GB  
    ubuntu - latest - b1d9d... - 4 weeks ago - 78.1MB  

---

### **2. Соберите собственный Docker-образ**

#### Шаги:

1. Создайте файл `Dockerfile` со следующим содержимым:
   ```Dockerfile
   FROM ubuntu:latest
   RUN apt-get update && apt-get install -y curl
   CMD ["echo", "Custom Docker Image!"]
   ```
   **Пример работы**:
   slava@Debian:~$ touch Dockerfile  
   slava@Debian:~$ pluma Dockerfile  
   


2. Соберите образ:
   ```bash
   docker build -t my-custom-image .
   ```
   **Возвращает:** Процесс сборки с логами, включая выполнение каждого шага `Dockerfile`. После завершения образ появится в списке локальных образов.
   **Пример работы**:
   slava@Debian:~$ docker build -t my-custom-image .  
   [+] Building 0.4s (5/5) FINISHJED docker:default  
   Дальше идет лог установки  

3. Запустите контейнер из образа:
   ```bash
   docker run my-custom-image
   ```
   **Возвращает:** Вывод команды, указанной в `CMD`. В данном случае: `Custom Docker Image!`.
   **Пример работы**:
   slava@Debian:~$ docker run my-custom-image  
   Custom Docker Image!  

---

### **3. Ознакомьтесь с командами Docker-клиента**

#### Команды:

- **Удаление контейнера:**
  ```bash
  docker rm <container_id>
  ```
  **Возвращает:** Удаление указанного контейнера. Если контейнер работает, потребуется добавить флаг `-f`.

- **Удаление образа:**
  ```bash
  docker rmi <image_id>
  ```
  **Возвращает:** Удаление указанного образа. Если есть связанные контейнеры, удаление может быть заблокировано.

- **Просмотр запущенных контейнеров:**
  ```bash
  docker ps
  ```
  **Возвращает:** Таблицу с информацией о запущенных контейнерах: их ID, имя, статус, порт и использованный образ.

- **Просмотр всех контейнеров:**
  ```bash
  docker ps -a
  ```
  **Возвращает:** Таблицу со всеми контейнерами (включая остановленные).

- **Создание сети:**
  ```bash
  docker network create my-network
  ```
  **Возвращает:** Уникальный идентификатор созданной сети.

- **Создание тома:**
  ```bash
  docker volume create my-volume
  ```
  **Возвращает:** Имя созданного тома.

---

### **4. Изучите флаги команды `run`**

#### Примеры:

- **Монтирование тома (`-v`)**:
  ```bash
  docker run -v /host/path:/container/path ubuntu ls /container/path
  ```
  **Возвращает:** Содержимое каталога `/container/path`, смонтированного из `/host/path`.

- **Проброс порта (`-p`)**:
  ```bash
  docker run -p 8080:80 nginx
  ```
  **Возвращает:** Запущенный Nginx, доступный локально на порту `8080`.

- **Удаление контейнера после завершения (`--rm`)**:
  ```bash
  docker run --rm ubuntu echo "Temporary container"
  ```
  **Возвращает:** Сообщение `Temporary container`. Контейнер автоматически удаляется после завершения.

- **Присвоение имени контейнеру (`--name`)**:
  ```bash
  docker run --name my-container ubuntu echo "Named container"
  ```
  **Возвращает:** Сообщение `Named container`. Контейнер будет доступен по имени `my-container`.

- **Рестарт контейнера при сбое (`--restart`)**:
  ```bash
  docker run --restart always ubuntu
  ```
  **Возвращает:** Контейнер, который автоматически перезапустится при сбое или остановке.

- **Интерактивный режим (`-i` и `-t`)**:
  ```bash
  docker run -it ubuntu bash
  ```
  **Возвращает:** Открытую командную строку внутри контейнера.

- **Фоновый режим (`-d`)**:
  ```bash
  docker run -d nginx
  ```
  **Возвращает:** ID запущенного контейнера. Контейнер работает в фоновом режиме.