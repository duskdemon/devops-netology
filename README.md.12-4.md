# Домашнее задание к занятию "12.4 Развертывание кластера на собственных серверах, лекция 2"
Новые проекты пошли стабильным потоком. Каждый проект требует себе несколько кластеров: под тесты и продуктив. Делать все руками — не вариант, поэтому стоит автоматизировать подготовку новых кластеров.

## Задание 1: Подготовить инвентарь kubespray
Новые тестовые кластеры требуют типичных простых настроек. Нужно подготовить инвентарь и проверить его работу. Требования к инвентарю:
* подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды;
* в качестве CRI — containerd;
* запуск etcd производить на мастере.  

**Решение:**  

1. Создаем на облаке яндкса 1 мастер ноду и 4 воркер-ноды.  
Скриншот созданных ВМ  
![ВМ в обаке Яндекса](https://github.com/duskdemon/devops-netology/blob/main/yc_vms_clust.png)  

2. Заходим по ssh на мастер ноду и на ней: устанавливаем kubespray, устанавливаем указанные в requirements пакеты, копируем шаблон
```
git clone https://github.com/kubernetes-sigs/kubespray
pip3 install -r requirements.txt
cp -rfp inventory/sample inventory/cluster
```
3. Делаем конфигурацию с помощью билдера:
```
declare -a IPS=(10.129.0.3 10.129.0.4 10.129.0.10 10.129.0.31 10.129.0.26)
CONFIG_FILE=inventory/cluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
```
4. Правим файл hosts.yaml под заданную конфигурацию:
```
all:
  hosts:
    node1:
      ansible_host: 10.129.0.3
      ip: 10.129.0.3
      access_ip: 10.129.0.3
    node2:
      ansible_host: 10.129.0.4
      ip: 10.129.0.4
      access_ip: 10.129.0.4
    node3:
      ansible_host: 10.129.0.10
      ip: 10.129.0.10
      access_ip: 10.129.0.10
    node4:
      ansible_host: 10.129.0.31
      ip: 10.129.0.31
      access_ip: 10.129.0.31
    node5:
      ansible_host: 10.129.0.26
      ip: 10.129.0.26
      access_ip: 10.129.0.26
  children:
    kube_control_plane:
      hosts:
        node1:
    kube_node:
      hosts:
        node2:
        node3:
        node4:
        node5:
    etcd:
      hosts:
        node1:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
```
Здесь, указывая __node1__ в секции __etcd__, соблюдаем условие задания.  
5. Добавляем  ключ для доступа по ssh с мастер ноды на воркеры.  
6. Добавляем внешний адрес мастер ноды в параметр supplementary_addresses_in_ssl_keys в файле k8s-cluster.yml.  
В этом же файле проверяем требование задания о том, что необходимо использовать containerd в качестве CRI:  
__container_manager: containerd__  
7. Запускаем плейбук и ждем, когда ансибл отработает:  
__ansible-playbook -i inventory/cluster/hosts.yaml cluster.yml -b -v__  
8. Для доступа создаем папку __.kube__ и копируем туда конфиг с мастер ноды:  
``` 
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
9. Вывод команды kubectl get nodes на мастер ноде:  
![вывод на мастер ноде](https://github.com/duskdemon/devops-netology/blob/main/cluster_nodes.png)  

10. Для возможности доступа со своей машины добавляем в конфиг __-cluster__ с сертификатом с мастер ноды и её внешним адресом.  
11. Со своей машины проверяем возможность работы с кластером:  
![вывод на своей машине](https://github.com/duskdemon/devops-netology/blob/main/cluster_acc.png)  

