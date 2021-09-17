#devops-netology
### 05-virt-03-docker-usage
#### Задача 1
Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование докера? Или лучше подойдет виртуальная машина, физическая машина? Или возможны разные варианты?"  
Детально опишите и обоснуйте свой выбор.
--
Сценарий:
Высоконагруженное монолитное java веб-приложение;
Go-микросервис для генерации отчетов;
Nodejs веб-приложение;
Мобильное приложение c версиями для Android и iOS;
База данных postgresql используемая, как кэш;
Шина данных на базе Apache Kafka;
Очередь для Logstash на базе Redis;
Elastic stack для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
Мониторинг-стек на базе prometheus и grafana;
Mongodb, как основное хранилище данных для java-приложения;
Jenkins-сервер.  
**Ответ:**
* _Высоконагруженное монолитное java веб-приложение;_ 
судя по тому, что нагрузка высокая, необходима производительность - вариант для железного сервера;
* _Go-микросервис для генерации отчетов;_
хороший вариант для использования docker-контейнеров;
* _Nodejs веб-приложение;_
думаю, тут тоже хорошо подойдет контейнеризация;
* _Мобильное приложение c версиями для Android и iOS;_
мобильное приложение - классическая виртуализация;
* _База данных postgresql используемая, как кэш;_
СУБД, да еще и кэш - думаю, тут железный сервер для наибольшей скорости;
* _Шина данных на базе Apache Kafka;_
 думаю, в случае небольших масштабов данных, возможна контейнеризация, на docker hub есть много имеджей;
* _Очередь для Logstash на базе Redis;_
Redis - СУБД, если предполагается высокая нагрузка - лучше в железе, а так можно и виртуальную машину;
* _Elastic stack для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;_
 Elasticsearсh можно на виртуалку в кластер, kibana и logstash в docker;
* _Мониторинг-стек на базе prometheus и grafana;_
полагаю, контейнеризация подойдет, т.к. указанные инструменты используются для мониторинга и метрик, сравнительно небольшая нагрузка и возможности для масштабирования;
* _Mongodb, как основное хранилище данных для java-приложения;_
виртуальная машина подойдет, контейнеризация тут вроде излишнее;
* _Jenkins-сервер._
сервер разработки, возможно использовать в docker.

#### Задача 2
Сценарий выполения задачи:

* создайте свой репозиторий на докерхаб;
* выберете любой образ, который содержит апачи веб-сервер;
* создайте свой форк образа;
* реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
``` <html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m kinda DevOps now</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на докерхаб-репо.
**Ответ:**  
Создав аккаунт на docker hub, скачал и установил docker desktop for windows. Выбрал для задания bitnami/apache.
Предварительно создав файл index.html с указанным содержимым, кладем его в C:\temp. Далее запускаем:
```
PS C:\WINDOWS\system32> docker run --name apache -v C:\temp:/app -p 8080:8080 bitnami/apache:latest
apache 21:07:46.22
apache 21:07:46.23 Welcome to the Bitnami apache container
apache 21:07:46.23 Subscribe to project updates by watching https://github.com/bitnami/bitnami-docker-apache
apache 21:07:46.23 Submit issues and feature requests at https://github.com/bitnami/bitnami-docker-apache/issues
apache 21:07:46.23
apache 21:07:46.23 INFO  ==> ** Starting Apache setup **
apache 21:07:46.25 INFO  ==> Mounting application files from '/app'

apache 21:07:46.26 INFO  ==> ** Apache setup finished! **
apache 21:07:46.27 INFO  ==> ** Starting Apache **
[Wed Sep 15 21:07:46.301139 2021] [ssl:warn] [pid 1] AH01909: www.example.com:8443:0 server certificate does NOT include an ID which matches the server name
[Wed Sep 15 21:07:46.306925 2021] [ssl:warn] [pid 1] AH01909: www.example.com:8443:0 server certificate does NOT include an ID which matches the server name
[Wed Sep 15 21:07:46.308170 2021] [mpm_prefork:notice] [pid 1] AH00163: Apache/2.4.48 (Unix) OpenSSL/1.1.1d configured -- resuming normal operations
[Wed Sep 15 21:07:46.308205 2021] [core:notice] [pid 1] AH00094: Command line: '/opt/bitnami/apache/bin/httpd -f /opt/bitnami/apache/conf/httpd.conf -D FOREGROUND'
```
после чего в браузере по адресу localhost:8080 видим содержимое нашего index.html

Делаем форк и пуш в репозиторий:
```
PS C:\WINDOWS\system32> docker tag bitnami/apache:latest duskdemon/duskdemon:homework-5-3
PS C:\WINDOWS\system32> docker images
REPOSITORY            TAG            IMAGE ID       CREATED      SIZE
bitnami/apache        latest         95981935de0c   2 days ago   176MB
duskdemon/duskdemon   homework-5-3   95981935de0c   2 days ago   176MB
PS C:\WINDOWS\system32> docker ps -a
CONTAINER ID   IMAGE                   COMMAND                  CREATED        STATUS                      PORTS     NAMES
914c12df527c   bitnami/apache:latest   "/opt/bitnami/script…"   44 hours ago   Exited (0) 19 minutes ago             apache
PS C:\WINDOWS\system32> docker ps -a
CONTAINER ID   IMAGE                              COMMAND                  CREATED          STATUS                      PORTS     NAMES
fbaa6fd9efae   duskdemon/duskdemon:homework-5-3   "/opt/bitnami/script…"   35 seconds ago   Exited (0) 21 seconds ago             elegant_hopper
914c12df527c   bitnami/apache:latest              "/opt/bitnami/script…"   44 hours ago     Exited (0) 21 minutes ago             apache
PS C:\WINDOWS\system32> docker commit fbaa6fd9efae duskdemon/duskdemon:homework-5-3
sha256:54150c88c1abaf3bd770b33e03ee2fa08911b20f7fdb8e50b993b553f39ce046
PS C:\WINDOWS\system32> docker push duskdemon/duskdemon:homework-5-3
The push refers to repository [docker.io/duskdemon/duskdemon]
2cb067caea84: Pushed
9434bb7d17c6: Mounted from bitnami/apache
7178abe82cdd: Mounted from bitnami/apache
fdb2deea6ef9: Mounted from bitnami/apache
534ae58d3e61: Mounted from bitnami/apache
c326957cd312: Mounted from bitnami/apache
e658b2d372a5: Mounted from bitnami/apache
13920f2ab6f4: Mounted from bitnami/apache
84bb2ddd1b55: Mounted from bitnami/apache
82577be92073: Mounted from bitnami/apache
0a52e9e2dc78: Mounted from bitnami/apache
homework-5-3: digest: sha256:95e61433297c4a1d08a5107844d10276324860ce6bb002b05b8d1bd5f325407c size: 2621
```
Ссылка на репозиторий: __https://hub.docker.com/repository/docker/duskdemon/duskdemon__

#### Задача 3
* Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку info из текущей рабочей директории на хостовой машине в /share/info контейнера;
* Запустите второй контейнер из образа debian:latest в фоновом режиме, подключив папку info из текущей рабочей директории на хостовой машине в /info контейнера;
* Подключитесь к первому контейнеру с помощью exec и создайте текстовый файл любого содержания в /share/info ;
* Добавьте еще один файл в папку info на хостовой машине;
* Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /info контейнера.

**Ответ:**  
* Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку info из текущей рабочей директории на хостовой машине в /share/info контейнера;
_тут я заранее сделал pull образа centos_
```
PS C:\WINDOWS\system32> docker run -dit -v C:\temp\info:/share/info centos:latest bash
b24cc91126ebd81549dee897a77adf538cda0770c0e8afa16fe758bee71189f2
PS C:\WINDOWS\system32> docker ps
CONTAINER ID   IMAGE           COMMAND   CREATED         STATUS         PORTS     NAMES
b24cc91126eb   centos:latest   "bash"    4 minutes ago   Up 4 minutes             naughty_margulis
```
* Запустите второй контейнер из образа debian:latest в фоновом режиме, подключив папку info из текущей рабочей директории на хостовой машине в /info контейнера;
```
PS C:\WINDOWS\system32> docker run -dit -v C:\temp\info:/share/info debian:latest bash
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
955615a668ce: Pull complete
Digest: sha256:08db48d59c0a91afb802ebafc921be3154e200c452e4d0b19634b426b03e0e25
Status: Downloaded newer image for debian:latest
8550fb6e830bb5ba718bccfc4649682909906d99cd99d1d04a46884c20abb97f
PS C:\WINDOWS\system32> docker ps
CONTAINER ID   IMAGE           COMMAND   CREATED              STATUS              PORTS     NAMES
8550fb6e830b   debian:latest   "bash"    About a minute ago   Up About a minute             epic_allen
b24cc91126eb   centos:latest   "bash"    11 minutes ago       Up 11 minutes                 naughty_margulis
```
* Подключитесь к первому контейнеру с помощью exec и создайте текстовый файл любого содержания в /share/info ;
```
PS C:\WINDOWS\system32> docker exec -it b24cc91126eb /bin/bash
[root@b24cc91126eb /]# ls
bin  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  share  srv  sys  tmp  usr  var
[root@b24cc91126eb /]# cd /share/info/
[root@b24cc91126eb info]# touch textfile
```
* Добавьте еще один файл в папку info на хостовой машине;
```
...
```
* Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /info контейнера.
```
PS C:\WINDOWS\system32> docker exec -it 8550fb6e830b /bin/bash
root@8550fb6e830b:/# cd /share/info
root@8550fb6e830b:/share/info# ls -al
total 4
drwxrwxrwx 1 root root 4096 Sep 17 17:34 .
drwxr-xr-x 3 root root 4096 Sep 17 17:28 ..
-rwxrwxrwx 1 root root    0 Sep 17 17:33 newfile.txt
-rw-r--r-- 1 root root    0 Sep 17 17:32 textfile
```
