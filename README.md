#devops-netology
# 04-script-03-yaml
1. Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
{ "info" : "Sample JSON output from our service\t",
    "elements" :[
        { "name" : "first",
        "type" : "server",
        "ip" : 7175 
        },
        { "name" : "second",
        "type" : "proxy",
        "ip : 71.78.22.43
        }
    ]
}
```
Нужно найти и исправить все ошибки, которые допускает наш сервис  
**Ответ:**  
Добавил недостающие двойные кавычки""" в строке 9:
```
{ "info" : "Sample JSON output from our service\t",
    "elements" :[
        { "name" : "first",
        "type" : "server",
        "ip" : 7175 
        },
        { "name" : "second",
        "type" : "proxy",
        "ip" : "71.78.22.43"
        }
    ]
}
```
2. В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.  
**Ответ:**   
Дополняем скрипт:
```
#!/usr/bin/env python3

import os
import socket
import datetime
import time
import json
import yaml

i = 1

servers = {'drive.google.com':'111.111.111.111', 'mail.google.com':'222.222.222.222', 'google.com':'333.333.333.333'}

while 1 == 1:
  for host in servers:
    ip = socket.gethostbyname(host)
    if ip != servers[host]:
        print(str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) +' [ERR] ' + str(host) +' wrong IP: '+servers[host]+' '+ip)
        servers[host] = ip
        with open("log_"+host+".json", 'w') as js:
          json_data = json.dumps([{host : ip}])
          js.write(json_data)
        with open("log_"+host+".yaml", 'w') as ym:
          yaml_data = yaml.dump([{host : ip}])
          ym.write(yaml_data)
  i+=1
  time.sleep(10)
```
Скрипт пишет информацию в файлы:
* log_drive.google.com.json
* log_drive.google.com.yaml
* log_google.com.json
* log_google.com.yaml
* log.mail.google.com.json
* log.mail.google.com.yaml

содержимое вида:
[{"drive.google.com": "173.194.220.194"}]
