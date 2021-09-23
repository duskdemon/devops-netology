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
