#devops-netology
03-sysadmin-05-fs

1. Узнайте о sparse (разряженных) файлах.

Ответ: Разрежённый файл (англ. sparse file) — файл, в котором последовательности нулевых байтов заменены на информацию об этих последовательностях (список дыр).

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Ответ: Нет, т.к. это жесткая ссылка. Ссылка всего-лишь указывает на объект. Если у объекта сменить права доступа или владельца, то все ссылки, указывающие на него сответственно покажут одни и те же права.

3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.provider :virtualbox do |vb|
    lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
    lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
    vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
    vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
  end
end
Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

Ответ: выполнено.

4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

Ответ: после работы в выводе fdisk -l получилось:
Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux

5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.

Ответ: используя O и I записал и загрузил скрипт-файл для /dev/sdc. После работы в выводе fdisk -l получилось:
Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

6. Соберите mdadm RAID1 на паре разделов 2 Гб.

Ответ: вывод lsblk
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdb2                 8:18   0  511M  0 part
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdc2                 8:34   0  511M  0 part

7. Соберите mdadm RAID0 на второй паре маленьких разделов.

Ответ: вывод lsblk
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdb2                 8:18   0  511M  0 part
  └─md1                9:1    0 1018M  0 raid0
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdc2                 8:34   0  511M  0 part
  └─md1                9:1    0 1018M  0 raid0

8. Создайте 2 независимых PV на получившихся md-устройствах.

Ответ: вывод sudo pvscan после создания (pvcreate)
  PV /dev/sda5   VG vgvagrant       lvm2 [<63.50 GiB / 0    free]
  PV /dev/md0                       lvm2 [<2.00 GiB]
  PV /dev/md1                       lvm2 [1018.00 MiB]
  Total: 3 [<66.49 GiB] / in use: 1 [<63.50 GiB] / in no VG: 2 [2.99 GiB]

9. Создайте общую volume-group на этих двух PV.

Ответ: sudo vgcreate vgr_01 /dev/md0 /dev/md1 Вывод sudo pvscan:
PV /dev/sda5   VG vgvagrant       lvm2 [<63.50 GiB / 0    free]
  PV /dev/md0    VG vgr_01          lvm2 [<2.00 GiB / <2.00 GiB free]
  PV /dev/md1    VG vgr_01          lvm2 [1016.00 MiB / 1016.00 MiB free]
  Total: 3 [66.48 GiB] / in use: 3 [66.48 GiB] / in no VG: 0 [0   ]

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

Ответ: sudo lvcreate -L 100M -n logvol1 vgr_01 /dev/md1, вывод lvscan:
 ACTIVE            '/dev/vgvagrant/root' [<62.54 GiB] inherit
  ACTIVE            '/dev/vgvagrant/swap_1' [980.00 MiB] inherit
  ACTIVE            '/dev/vgr_01/logvol1' [100.00 MiB] inherit

11. Создайте mkfs.ext4 ФС на получившемся LV.

Ответ:sudo mkfs.ext4 /dev/vgr_01/logvol1, вывод:
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done

12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.

Ответ:sudo mkdir /mnt/lv1, sudo mount /dev/vgr_01/logvol1 /mnt/lv1/.

13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.

Ответ: sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O testfile.gz

14. Прикрепите вывод lsblk.

Ответ:
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdb2                 8:18   0  511M  0 part
  └─md1                9:1    0 1018M  0 raid0
    └─vgr_01-logvol1 253:2    0  100M  0 lvm   /mnt/lv1
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdc2                 8:34   0  511M  0 part
  └─md1                9:1    0 1018M  0 raid0
    └─vgr_01-logvol1 253:2    0  100M  0 lvm   /mnt/lv1

15. Протестируйте целостность файла:

root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0

Ответ:vagrant@vagrant:/mnt/lv1$ gzip -t testfile.gz
vagrant@vagrant:/mnt/lv1$ echo $?
0

16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

Ответ:
vagrant@vagrant:/mnt/lv1$ sudo pvmove /dev/md1 /dev/md0
  /dev/md1: Moved: 16.00%
  /dev/md1: Moved: 100.00%
vagrant@vagrant:/mnt/lv1$ sudo pvscan
  PV /dev/sda5   VG vgvagrant       lvm2 [<63.50 GiB / 0    free]
  PV /dev/md0    VG vgr_01          lvm2 [<2.00 GiB / <1.90 GiB free]
  PV /dev/md1    VG vgr_01          lvm2 [1016.00 MiB / 1016.00 MiB free]
  Total: 3 [66.48 GiB] / in use: 3 [66.48 GiB] / in no VG: 0 [0   ]

17. Сделайте --fail на устройство в вашем RAID1 md.

Ответ:
vagrant@vagrant:/$ sudo mdadm --fail /dev/md0 /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0

18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.

Ответ:вывод dmesg:
[ 7357.991863] md/raid1:md0: Disk failure on sdb1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.

19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0

Ответ:
vagrant@vagrant:/$ gzip -t /mnt/lv1/testfile.gz
vagrant@vagrant:/$ echo $?
0

20. Погасите тестовый хост, vagrant destroy. 

Ответ:
PS C:\Users\Dusk\vagrant> vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
PS C:\Users\Dusk\vagrant>
