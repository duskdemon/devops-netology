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
