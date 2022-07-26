
# Домашнее задание к занятию "10.03. Grafana"

## Обязательные задания

### Задание 1
Используя директорию [help](./help) внутри данного домашнего задания - запустите связку prometheus-grafana.

Зайдите в веб-интерфейс графана, используя авторизационные данные, указанные в манифесте docker-compose.

Подключите поднятый вами prometheus как источник данных.

Решение домашнего задания - скриншот веб-интерфейса grafana со списком подключенных Datasource.  

**Решение:**  
![интерфейс Графаны](https://github.com/duskdemon/devops-netology/blob/main/graf_ds01.png)

## Задание 2
Изучите самостоятельно ресурсы:
- [promql-for-humans](https://timber.io/blog/promql-for-humans/#cpu-usage-by-instance)
- [understanding prometheus cpu metrics](https://www.robustperception.io/understanding-machine-cpu-usage)

Создайте Dashboard и в ней создайте следующие Panels:
- Утилизация CPU для nodeexporter (в процентах, 100-idle)
- CPULA 1/5/15
- Количество свободной оперативной памяти
- Количество места на файловой системе

Для решения данного ДЗ приведите promql запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.  
**Решение:**  
- ```100*(rate(node_cpu_seconds_total{mode="system", instance="nodeexporter:9100"}[10m]))```
- ```node_load1{instance="nodeexporter:9100"}```,- ```node_load5{instance="nodeexporter:9100"}```,- ```node_load15{instance="nodeexporter:9100"}```  
- ```node_memory_MemFree_bytes{instance="nodeexporter:9100", job="nodeexporter"}/ (1024 * 1024 * 1024)```
- ```node_filesystem_avail_bytes{device="/dev/vda2", fstype="xfs", instance="nodeexporter:9100", job="nodeexporter", mountpoint="/"}/(1024*1024*1024)```  
![дашбоард Графаны](https://github.com/duskdemon/devops-netology/blob/main/graf_dash01.png)

## Задание 3
Создайте для каждой Dashboard подходящее правило alert (можно обратиться к первой лекции в блоке "Мониторинг").

Для решения ДЗ - приведите скриншот вашей итоговой Dashboard.  
**Решение:**  
 ![дашбоард Графаны c алертами](https://github.com/duskdemon/devops-netology/blob/main/graf_dash02.png)  
 
 ![скрин c алертами в ТГ](https://github.com/duskdemon/devops-netology/blob/main/Screenshot_20220726-220130_Telegram.jpg)

## Задание 4
Сохраните ваш Dashboard.

Для этого перейдите в настройки Dashboard, выберите в боковом меню "JSON MODEL".

Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.

В решении задания - приведите листинг этого файла.  
**Решение:**  

Листинг файла  
![json](https://github.com/duskdemon/devops-netology/blob/main/103-dash.json)
