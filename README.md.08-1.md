#devops-netology
### 08-ansible-01-basics

# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

---

## Ответы:

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
**Ответ:**
```yml
dusk@DUSK-LT:/mnt/c/Users/Dusk/devops-netology-ansible-1$ ansible-playbook site.yml -i inventory/test.yml
```
__some_fact=12__
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
**Ответ:**
dusk@DUSK-LT:/mnt/c/Users/Dusk/devops-netology-ansible-1$ cat group_vars/all/examp.yml 
`---
  some_fact: all default fact
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
**Ответ:**
Подготовил 2 хоста в докере:
```
dusk@DUSK-LT:/mnt/c/Users/Dusk/devops-netology-ansible-1$ docker ps
CONTAINER ID   IMAGE               COMMAND       CREATED          STATUS          PORTS     NAMES
1aed4bff8a90   pycontribs/alpine   "/bin/bash"   4 seconds ago    Up 2 seconds              alpine
b1ba329298e0   pycontribs/debian   "/bin/bash"   33 seconds ago   Up 31 seconds             debian
```
Поправил файл prod.yml, хосты alpine и debian  
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
**Ответ:**
```
TASK [Print fact] *******************************************************************************
ok: [alpine] => {
    "msg": "el"
}
ok: [debian] => {
    "msg": "deb"
}
```
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
**Ответ:**
Внес правки в файлы examp.yml  
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
**Ответ:**
```
TASK [Print fact] *******************************************************************************
ok: [alpine] => {
    "msg": "el default fact"
}
ok: [debian] => {
    "msg": "deb default fact"
}
```
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
**Ответ:**
Предварительно создав файл pwsd с паролем внутри, шифруем:
```
dusk@DUSK-LT:/mnt/c/Users/Dusk/devops-netology-ansible-1$ ansible-vault encrypt_string --vault-password-file /home/dusk/pswd 'deb default fact' --name 'secret_fact'
secret_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          64666339643538396437356362363763343536383165356334616462626338323631643161346237
          3066313632653433636434356330373133306236313966640a323365306636663934353032376135
          33663263363631663766636235323962666662373033363063366665336435383565653238396331
          6330663738346533620a366461373537653136366663363533393161636438386562346265636133
          39393530353738376130663664623736333434333736383532623337393432313135
Encryption successful
dusk@DUSK-LT:/mnt/c/Users/Dusk/devops-netology-ansible-1$ ansible-vault encrypt_string --vault-password-file /home/dusk/pswd 'el default fact' --name 'secret_fact_el'
secret_fact_el: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          35343166616331396138353061626364636461636535616532313031386339646464316662643937
          6465343235393465396334376364396266643163336561370a323339666133643065643164646633
          32313635623236323266386436386534343636306365623161393264306639623063356665376262
          3630653666303835310a353535663835393464363832306531646435323232396530363631306336
          6362
Encryption successful
```
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
**Ответ:**
```
dusk@DUSK-LT:/mnt/c/Users/Dusk/devops-netology-ansible-1$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ***************************************************************************

TASK [Gathering Facts] **************************************************************************
[WARNING]: Platform linux on host alpine is using the discovered Python interpreter at
/usr/bin/python3.8, but future installation of another Python interpreter could change the
meaning of that path. See https://docs.ansible.com/ansible-
core/2.11/reference_appendices/interpreter_discovery.html for more information.
ok: [alpine]
ok: [debian]

TASK [Print OS] *********************************************************************************
ok: [alpine] => {
    "msg": "Alpine"
}
ok: [debian] => {
    "msg": "Debian"
}

TASK [Print fact] *******************************************************************************
ok: [alpine] => {
    "msg": "el default fact"
}
ok: [debian] => {
    "msg": "deb default fact"
}

PLAY RECAP **************************************************************************************
alpine                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
debian                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
**Ответ:**
Смотрим список плагинов и выбираем нужный:
```
dusk@DUSK-LT:/mnt/c/Users/Dusk/devops-netology-ansible-1$ ansible-doc -t connection -l
```

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
**Ответ:**
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
**Ответ:**
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.
**Ответ:**
