#devops-netology
03-sysadmin-04-os

1. На лекции мы познакомились с node_exporter. В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter:

поместите его в автозагрузку,
предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на systemctl cat cron),
удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

Ответ: Установка node_exporter:
Создаем пользователя - sudo useradd node_exporter -s /sbin/nologin;
забираем при помощи wget, разархивируем, копируем в /usr/sbin;
создаем файл /etc/systemd/system/node_exporter.service:

[Unit]
Description=Node Exporter

[Service]
User=node_exporter
EnvironmentFile=/etc/sysconfig/node_exporter
ExecStart=/usr/sbin/node_exporter-1.1.2.linux-amd64/node_exporter $OPTIONS

[Install]
WantedBy=multi-user.target

создаем каталог и файл /etc/sysconfig/node_exporter и прописываем в него опции.
Далее sudo systemctl daemon-reload, sudo systemctl enable node_exporter.
curl http://localhost:9100/metrics - информация доступна по метрикам здесь.

2. Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

Ответ: Стандартные коллекторы: cpu, diskstats, filesystem, hwmon, meminfo, netstat.

3. Установите в свою виртуальную машину Netdata. Воспользуйтесь готовыми пакетами для установки (sudo apt install -y netdata). После успешной установки:

в конфигурационном файле /etc/netdata/netdata.conf в секции [web] замените значение с localhost на bind to = 0.0.0.0,
добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте vagrant reload:
config.vm.network "forwarded_port", guest: 19999, host: 19999
После успешной перезагрузки в браузере на своем ПК (не в виртуальной машине) вы должны суметь зайти на localhost:19999. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

Ответ: после установки по инструкции изменил в netdata.conf строку в [global] на такую: bind socket to IP = 0.0.0.0 . после проброса порта 19999 через вагрант, стала доступна страница со статистикой netdata в хост-системе. Скриншот прилагаю

4. Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?

Ответ: dmesg | grep virtual
[    0.007849] CPU MTRRs all blank - virtualized system.

5. Как настроен sysctl fs.nr_open на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (ulimit --help)?

Ответ: По-умолчанию лимит на количество открытых файлов:
/sbin/sysctl -n fs.nr_open = 1048576.
ulimit -n 1024; ulimit -n -H 1048576. 

6. Запустите любой долгоживущий процесс (не ls, который отработает мгновенно, а, например, sleep 1h) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter. Для простоты работайте в данном задании под root (sudo -i). Под обычным пользователем требуются дополнительные опции (--map-root-user) и т.д.

Ответ:
root@vagrant:~# ushare -f --pid --mount-proc sleep 30m
bash: ushare: command not found
root@vagrant:~# unshare -f --pid --mount-proc sleep 30m
^Z
[1]+  Stopped                 unshare -f --pid --mount-proc sleep 30m
root@vagrant:~# ps -a | grep sleep
   1892 pts/1    00:00:00 sleep
root@vagrant:~# sudo -i
root@vagrant:~# nsenter --target 1892 --pid --mount
root@vagrant:/# ps -aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   8076   528 pts/1    S    08:12   0:00 sleep 30m
root           2  0.0  0.3   9836  3968 pts/1    S    08:14   0:00 -bash
root          11  0.0  0.3  11680  3616 pts/1    R+   08:14   0:00 ps -aux
root@vagrant:/#

7. Найдите информацию о том, что такое :(){ :|:& };:. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов dmesg расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

Ответ: Через некоторое время после запуска получил множественные сообщения вида
-bash: fork: Resource temporarily unavailable. В выводе dmesg нашлось:
cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-4.scope
При помощи cgroups можно ограничить количество создаваемых процессов, при помощи контроллера CONFIG_CGROUP_PIDS. 
