1. Создание Dockerfile для отладки сервера

```Dockerfile
FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    curl \
    net-tools \
    procps \
    apache2-utils \
    curl \
    strace \
    && rm -rf /var/lib/apt/lists/*

COPY serverTest /usr/local/bin/serverTest

RUN chmod +x /usr/local/bin/serverTest

WORKDIR /usr/local/bin

EXPOSE 8080

CMD ["./serverTest"]
```

2. Создаем докер образ с помощью докер образа

```bash
docker build -t my_server_image .
```

3. Запускаем докер образ в фоне, с портом 8080 и лимитом наоткрытие файлов 1024

```bash
docker run -d -p 8080:8080 --ulimit nofile=1024:1024 --name my_server_container my_server_image
```

4. Проверяем лимит запросов с помощью утилиты ab. Где флак n указывает количество флаг c параллельное количесвто запросов.

```bash
ab -n 2000 -c 100 http://localhost:8080/
```

Ответ утилиты:

```bash
Benchmarking localhost (be patient)
Completed 200 requests
Completed 400 requests
Completed 600 requests
Completed 800 requests
Completed 1000 requests
Completed 1200 requests
Completed 1400 requests
Completed 1600 requests
Completed 1800 requests
Completed 2000 requests
Finished 2000 requests


Server Software:
Server Hostname:        localhost
Server Port:            8080

Document Path:          /
Document Length:        19 bytes

Concurrency Level:      100
Time taken for tests:   1.358 seconds
Complete requests:      2000
Failed requests:        0
Non-2xx responses:      2000
Total transferred:      352000 bytes
HTML transferred:       38000 bytes
Requests per second:    1472.47 [#/sec] (mean)
Time per request:       67.913 [ms] (mean)
Time per request:       0.679 [ms] (mean, across all concurrent requests)
Transfer rate:          253.08 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   1.6      0      11
Processing:    12   66  13.5     65     106
Waiting:        0   66  13.6     65     106
Total:         12   67  12.9     65     106

Percentage of the requests served within a certain time (ms)
  50%     65
  66%     70
  75%     76
  80%     79
  90%     84
  95%     88
  98%     94
  99%     98
 100%    106 (longest request)
```

Отсюда мы можем выяснить:
- Complete requests: 2000. Все запросы были выполнены и ответ от сервера сразу пришел
- Non-2xx responses: 2000. Ни один ответ не пришел с ответом 200, значит он возвращает ошибку 4xx, 5xx

5. Проверяем логи докера, возможно были выкинуты какие-то ошибки.

```bash
docker logs my_server_container

Starting server at :8080
```

Ошибки не были выброшены сервером, значит все окей.

6. Проверяем эндпоинт */*

```bash
curl -v http://localhost:8080/

*   Trying ::1:8080...
* connect to ::1 port 8080 failed: Connection refused
*   Trying 127.0.0.1:8080...
* Connected to localhost (127.0.0.1) port 8080 (#0)
> GET / HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.74.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 404 Not Found
< Content-Type: text/plain; charset=utf-8
< X-Content-Type-Options: nosniff
< Date: Mon, 21 Oct 2024 18:03:58 GMT
< Content-Length: 19
<
404 page not found
* Connection #0 to host localhost left intact
```

Видим, что запрос по маршруту 127.0.0.1:8080 прошел. Выполнился GET запрос, но этот endpoint не был найден.

7. Заходим в докер контейнер и проверяем zombie процессы. После этого запускаем strace, прокидываем вновь 1000 запросов и смотрим, системные вызовы сервера.

```bash
docker exec -it my_server_container bash

ps -aux | grep 'Z'
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root          25  0.0  0.2   3528  1580 pts/0    S+   18:07   0:00 grep --color=auto Z

strace -p 11

futex(0x958280, FUTEX_WAIT_PRIVATE, 0, NULL
) = 0
epoll_pwait(5, [], 128, 0, NULL, 0)     = 0
futex(0x959ca0, FUTEX_WAKE_PRIVATE, 1)  = 1
epoll_pwait(5, [], 128, 0, NULL, 0)     = 0
futex(0x959ca0, FUTEX_WAKE_PRIVATE, 1)  = 1
futex(0x959bb8, FUTEX_WAKE_PRIVATE, 1)  = 1
madvise(0xc00047c000, 8192, MADV_DONTNEED) = 0
madvise(0xc00045c000, 8192, MADV_DONTNEED) = 0
madvise(0xc000454000, 8192, MADV_DONTNEED) = 0
madvise(0xc0003f0000, 8192, MADV_DONTNEED) = 0
madvise(0xc0001e0000, 8192, MADV_DONTNEED) = 0
madvise(0xc0001ca000, 24576, MADV_DONTNEED) = 0
write(7, "\0", 1)                       = 1
futex(0x958280, FUTEX_WAIT_PRIVATE, 0, NULL) = 0
madvise(0xc0001c4000, 24576, MADV_DONTNEED) = 0
madvise(0xc0001b8000, 40960, MADV_DONTNEED) = 0
madvise(0xc0001a6000, 65536, MADV_DONTNEED) = 0
madvise(0xc000198000, 57344, MADV_DONTNEED) = 0
madvise(0xc000194000, 8192, MADV_DONTNEED) = 0
futex(0x958280, FUTEX_WAIT_PRIVATE, 0, NULL

```

Исходя из логов видно, что futex и epoll_pwait сервер уходит в ожидание и все проходит хорошо.

Вызовы madvise просто освобождение памяти.

Вызов записи завершился успешно, потому что сервер следующим вызовом ушел в ожидание.

8. Пробуем вызвать endpoint bugs у сервера.

```bash
curl http://localhost:8080/bugs

Internal Server Error

```

Получаем Internal error, проверяем логи.

```bash
docker logs my_server_container

Recovered from panic: Random panic occurred!
```

Видим, что на сервере была вызвана паника.

9. Проверяем исскуственную задержку у сервера.

```bash
for i in {1..7}; do time curl http://localhost:8080 & done

real    0m0.205s
user    0m0.006s
sys     0m0.005s

real    0m0.208s
user    0m0.007s
sys     0m0.004s

real    0m0.216s
user    0m0.012s
sys     0m0.000s

real    0m0.230s
user    0m0.011s
sys     0m0.000s

real    0m0.242s
user    0m0.013s
sys     0m0.000s

real    0m0.238s
user    0m0.012s
sys     0m0.000s

real    0m0.217s
user    0m0.011s
sys     0m0.000s
```

Видим, что нет одинаковой задержки ответа от сервера. Время ответа варируется, отсюда можно сделать умозаключение, что нет задержки ответа сервреа. Либо я просто не знаю какие endpointы есть у сервера