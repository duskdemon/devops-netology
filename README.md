#devops-netology
03-sysadmin-03-os

1. Какой системный вызов делает команда cd? В прошлом ДЗ мы выяснили, что cd не является самостоятельной программой, это shell builtin, поэтому запустить strace непосредственно на cd не получится. Тем не менее, вы можете запустить strace на /bin/bash -c 'cd /tmp'. В этом случае вы увидите полный список системных вызовов, которые делает сам bash при старте. Вам нужно найти тот единственный, который относится именно к cd.

Ответ: chdir("/tmp")                           = 0

2. Попробуйте использовать команду file на объекты разных типов на файловой системе. Например:
vagrant@netology1:~$ file /dev/tty
/dev/tty: character special (5/0)
vagrant@netology1:~$ file /dev/sda
/dev/sda: block special (8/0)
vagrant@netology1:~$ file /bin/bash
/bin/bash: ELF 64-bit LSB shared object, x86-64
Используя strace выясните, где находится база данных file на основании которой она делает свои догадки.

Ответ: /usr/lib/file/magic.mgc. Выполнив strace file -c 'scr.sh' нашел строку openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3, далее нашел местонахождение файла, оказалось, что это ссылка. использовал для поиска find / -name magic.mgc

3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

Ответ: очистить файл можно: cat /dev/null > test

Дополнение: Файл test, редактируемый в vim (остановка по ctrl-z), удаляем. Ищем с помощью lsof | grep test PID связанный с файлом. Далее находим дескриптор, который используется для записи в файл через proc/<PID>/fd и cat /dev/null > /proc/6203/fd/3 

4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

Ответ: зомби-процессы занимают место в таблице процессов, которая имеет конечное количество записей. Есть вероятность при ее переполнении уронить систему. 

5. В iovisor BCC есть утилита opensnoop:
root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc
На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты? Воспользуйтесь пакетом bpfcc-tools для Ubuntu 20.04. Дополнительные сведения по установке.

Ответ: после запуска sudo opensnoop-bpfcc -d 10 (на 10 секунд) были обнаружены файлы vminfo, dbus-daemon, irqbalance.

6. Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.

Ответ: 'strace uname -a' по выводу нашел системный вызов uname. Альтернативное местоположение описано в man proc:
  /proc/version
              This  string  identifies  the  kernel  version  that is currently running.  It includes the contents of
              /proc/sys/kernel/ostype, /proc/sys/kernel/osrelease and /proc/sys/kernel/version.  For example:

        Linux version 1.0.9 (quinlan@phaze) #1 Sat May 14 01:51:54 EDT 1994

7. Чем отличается последовательность команд через ; и через && в bash? Например:
root@netology1:~# test -d /tmp/some_dir; echo Hi
Hi
root@netology1:~# test -d /tmp/some_dir && echo Hi
root@netology1:~#
Есть ли смысл использовать в bash &&, если применить set -e?

Ответ: в случае с ; команды выполняются одна за другой последовательно, а при использовании && вторая команда выполняется только при условии успешного выполнения первой. Если использовать -e, скрипт будет остановлен при получении ошибки, поэтому нет смысла использовать &&.

8. Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?

Ответ: Для set: -e останавливает выполнение при выводе ошибки, -u проверяет инициализацию переменной, если нет - останавливается выполнение, -x выводит в стандартный вывод команды перед их выполнением, а -o pipefail позволяет проверить что все команды во всех пайпах выполнены без ошибок. Это позволяет прервать скрипт, если что-либо идет не по плану.  

9. Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе. В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

Ответ: ps -e -o stat, далее считаем каких статусов процессов больше при помощи grep -c. На моей системе получилось больше в сатусе S interruptible sleep (waiting for an event to complete).  

