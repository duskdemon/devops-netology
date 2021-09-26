#devops-netology
### 05-virt-04-docker-practical-skills
#### Задача 1 
В данном задании вы научитесь изменять существующие Dockerfile, адаптируя их под нужный инфраструктурный стек.

Измените базовый образ предложенного Dockerfile на Arch Linux c сохранением его функциональности.
```
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:vincent-c/ponysay && \
    apt-get update
 
RUN apt-get install -y ponysay

ENTRYPOINT ["/usr/bin/ponysay"]
CMD ["Hey, netology”]
```
Для получения зачета, вам необходимо предоставить:

* Написанный вами Dockerfile
* Скриншот вывода командной строки после запуска контейнера из вашего базового образа
* Ссылку на образ в вашем хранилище docker-hub

**Ответ**
Докер-файл:
```
FROM archlinux:latest

RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm ponysay
	
ENTRYPOINT ["/usr/bin/ponysay"]
CMD ["Hey, netology"]
```

docker:

docker pull duskdemon/duskdemon:homework-5-4

ссыылка на картинку:

https://github.com/duskdemon/devops-netology/blob/main/ponee.jpg

#### Задача 2
В данной задаче вы составите несколько разных Dockerfile для проекта Jenkins, опубликуем образ в dockerhub.io и посмотрим логи этих контейнеров.

###### * Составьте 2 Dockerfile:

###### Общие моменты:
* Образ должен запускать Jenkins server
###### Спецификация первого образа:
* Базовый образ - amazoncorreto
* Присвоить образу тэг ver1
###### Спецификация второго образа:
* Базовый образ - ubuntu:latest
* Присвоить образу тэг ver2  
##### 
###### * Соберите 2 образа по полученным Dockerfile
###### * Запустите и проверьте их работоспособность
###### * Опубликуйте образы в своём dockerhub.io хранилище

Для получения зачета, вам необходимо предоставить:

* Наполнения 2х Dockerfile из задания
* Скриншоты логов запущенных вами контейнеров (из командной строки)
* Скриншоты веб-интерфейса Jenkins запущенных вами контейнеров (достаточно 1 скриншота на контейнер)
* Ссылки на образы в вашем хранилище docker-hub

**Ответ**

docker pull amazoncorretto:latest  
docker pull ubuntu:latest  

docker build -t duskdemon/duskdemon:ver1 -f a_ver1 .  
docker run -p 8085:8080 -p 50005:50000 -w /usr/lib/jenkins/ -i -t duskdemon/duskdemon:ver1 java -jar jenkins.war  

docker build -t duskdemon/duskdemon:ver2 -f u_ver2 .  
docker run -p 8086:8080 -p 50006:50000 -w /usr/share/jenkins/ -i -t duskdemon/duskdemon:ver2 java -jar jenkins.war  

##### докер-файлы: a_ver1, u_ver2
```
FROM amazoncorretto

RUN yum install wget -y
RUN wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
RUN rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
RUN amazon-linux-extras install epel -y
RUN yum install java-11-amazon-corretto-devel.x86_64 jenkins update -y
CMD ["/bin/bash"]
```

```
FROM ubuntu

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install tzdata && apt-get install wget -y && apt-get install gnupg -y
RUN wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
RUN echo "deb https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list
RUN apt-get update && apt-get install openjdk-11-jdk -y && apt-get install jenkins -y 
CMD ["/bin/bash"]
```
##### ссылки на скриншоты: 

Логи:  
Амазонкорретто https://github.com/duskdemon/devops-netology/blob/main/amazon-jenkins01.jpg  
Убунту https://github.com/duskdemon/devops-netology/blob/main/ubuntu-jenkins01.jpg  

Веб-страницы:  
Амазонкорретто https://github.com/duskdemon/devops-netology/blob/main/amazon-jenkins02.jpg  
Убунту https://github.com/duskdemon/devops-netology/blob/main/ubuntu-jenkins02.jpg  

##### ссылки на репозиторий докер-хаб:  

docker pull duskdemon/duskdemon:ver1  
docker pull duskdemon/duskdemon:ver2  

#### Задача 3
В данном задании вы научитесь:

* объединять контейнеры в единую сеть
* исполнять команды "изнутри" контейнера

Для выполнения задания вам нужно:

###### Написать Dockerfile:

* Использовать образ https://hub.docker.com/_/node как базовый
* Установить необходимые зависимые библиотеки для запуска npm приложения https://github.com/simplicitesoftware/nodejs-demo
* Выставить у приложения (и контейнера) порт 3000 для прослушки входящих запросов
* Соберите образ и запустите контейнер в фоновом режиме с публикацией порта

###### Запустить второй контейнер из образа ubuntu:latest
* Создайть docker network и добавьте в нее оба запущенных контейнера
* Используя docker exec запустить командную строку контейнера ubuntu в интерактивном режиме
* Используя утилиту curl вызвать путь / контейнера с npm приложением

Для получения зачета, вам необходимо предоставить:

* Наполнение Dockerfile с npm приложением
* Скриншот вывода вызова команды списка docker сетей (docker network cli)
* Скриншот вызова утилиты curl с успешным ответом

**Ответ**

Сначала забираем образ из докер-хаба:
_docker pull node:latest_

докер-файл для сервера nodejs:

```
FROM node
RUN apt-get update
RUN git clone https://github.com/simplicitesoftware/nodejs-demo.git
WORKDIR /nodejs-demo/
RUN sed -i s/localhost/0.0.0.0/g app.js
RUN npm install
CMD npm start
```
билдим контейнер:
_docker build -t duskdemon/duskdemon:ver3-njs -f n_njsdemo ._

создаем сетевое пространство:

```
PS C:\temp> docker network create nodejs-demo
30139b6f3b56f0a0710f77ee839df429be683e0fe7a0f9ea4dee1ede8668ae72
PS C:\temp> docker network ls
NETWORK ID     NAME          DRIVER    SCOPE
6c6f57a03d4d   bridge        bridge    local
12bf184dbb17   host          host      local
30139b6f3b56   nodejs-demo   bridge    local
dd991d65e8ac   none          null      local
```
запускаем сервер:
_docker run -d -p 3000:3000 --net=nodejs-demo duskdemon/duskdemon:ver3-njs npm start_

подключаем в сеть убунту, заходим в контейнер:
_docker run -it --net=nodejs-demo ubuntu:latest bash_

внутри выполняем:
```
root@6fa2bd9bdfe7:/#apt-get update
root@6fa2bd9bdfe7:/#apt-get install curl
root@6fa2bd9bdfe7:/#curl 172.18.0.2:3000
```
получаем большую простыню, заканчивающуюся на 
```
urient fringilla euismod feugiat</p>","demoPrdBrochure":"10591","demoPrdOnlineDoc":null,"demoPrdComments":null}];
    var pc = $('#nodejs-demo-products');
    for (var i = 0; i < ps.length; i++) {
      var p = ps[i];
      pc.append(
        $('<li/>')
          .append($('<img/>', { title: p.demoPrdReference, src: 'data:' + p.demoPrdPicture.mime + ';base64,' + p.demoPrdPicture.content }))
          .append($('<h1/>').append(p.demoPrName))
          .append($('<h2/>').append(p.demoPrdReference))
          .append($('<p/>').append(p.demoPrdDescription))
        );
    }
});</script></head><body><div id="nodejs-demo"><div class="text-center" id="header"><img src="/logo.svg" alt="Logo"></div><ul id="nodejs-demo-products"></ul><p class="text-right">&copy; Simplict&eacute; Software, powered by&nbsp;<a href="https://expressjs.com" target="_blank">Express</a></p></div></body></html>root@6fa2bd9bdfe7:/#
```
ну, то есть, выдача страницы с сервера.

Ссылки на скриншоты:  
скриншот конфигурации сети докер https://github.com/duskdemon/devops-netology/blob/main/docker_nodejs01.jpg  
скриншот вывода curl https://github.com/duskdemon/devops-netology/blob/main/ubuntu-nodejs-curl01.jpg  
Ссылка на докер-файл:  
**docker pull duskdemon/duskdemon:ver3-njs**
