#devops-netology
# 04-script-02-py
1. Есть скрипт:
	```python
    #!/usr/bin/env python3
	a = 1
	b = '2'
	c = a + b
	```
	* Какое значение будет присвоено переменной c?
	* Как получить для переменной c значение 12?
	* Как получить для переменной c значение 3?
**Ответ:**
Не складывается, т.к. переменные разных типов:
```
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unsupported operand type(s) for +: 'int' and 'str'
```
Чтобы получить 12, преобразуем переменную *a* в тип *string*:
```
>>> a =str(a)
>>> a
'1'
>>> c = a + b
>>> c
'12'
```
Чтобы получить 3, нужно обе складываемые переменные преобразовать в *integer*:
```
a = int(a)
b = int(b)
>>> c = a + b
>>> c
3
```
2. Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

	```python
    #!/usr/bin/env python3

    import os

	bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
	result_os = os.popen(' && '.join(bash_command)).read()
    is_change = False
	for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print(prepare_result)
            break

	```
**Ответ:**
```python
#!/usr/bin python3

import os
path='/home/vagrant/devops-netology'

bash_command = ["cd " +path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
#is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        separator='/'
        out=path+separator+prepare_result
        print(out)
```
получилось так:
```python
vagrant@vagrant:~/devops-netology$ python3 check_ch01.py
/home/vagrant/devops-netology/testfile1
```

3. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

**Ответ:**
```python
#!/usr/bin python3

import os
import sys
path = os.getcwd()

bash_command = ["cd " +path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        separator='/'
        out=path+separator+prepare_result
        print(out)
```
4. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.

**Ответ:**
```python
#!/usr/bin/env python3

import os
import socket
import datetime
import time

i = 1

servers = {'drive.google.com':'111.111.111.111', 'mail.google.com':'222.222.222.222', 'google.com':'333.333.333.333'}

while 1 == 1:
  for host in servers:
    ip = socket.gethostbyname(host)
    if ip != servers[host]:
        print(str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) +' [ERR] ' + str(host) +' wrong IP: '+servers[host]+' '+ip)
        servers[host] = ip

  i+=1
  time.sleep(10)
```
