1. Dockerfile.cmd  

При простом запуске с формой CMD, будет выведен текст.
```bash
docker build -t cmd -f Dockerfile.cmd
docker run cmd
Hello from CMD!
```
Но мы можем его прямо переопределить
```bash
docker build -t cmd -f Dockerfile.cmd
docker run cmd ls
```
Тогда cmd лего переопределится


2. Dockerfile.entry

При простом запуске мы можем просто добавить аргумент к entrypoint, переопределить его не получится
```bash
docker build -t entrypoint -f Dockerfile.cmd
docker run entrypoint Hello
Hello
```

3. Dockerfile.cmd_enrty

При простом запуске мы можем просто добавить аргумент к entrypoint, переопределить его не получится
```bash
docker build -t cmd_entrypoint -f Dockerfile.cmd
docker run cmd_entrypoint
Hello from ENTRYPOINT and CMD!
```

Но если мы добавим новый текст, то мы сможем переопределить CMD часть и убрать аргумент по умолчанию к ENTRYPOINT

```bash
docker build -t cmd_entrypoint -f Dockerfile.cmd
docker run cmd_entrypoint Dimas
Dimas
```  