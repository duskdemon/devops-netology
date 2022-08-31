## Домашнее задание к занятию "12.3 Развертывание кластера на собственных серверах, лекция 1"
Поработав с персональным кластером, можно заняться проектами. Вам пришла задача подготовить кластер под новый проект.

## Задание 1: Описать требования к кластеру
Сначала проекту необходимо определить требуемые ресурсы. Известно, что проекту нужны база данных, система кеширования, а само приложение состоит из бекенда и фронтенда. Опишите, какие ресурсы нужны, если известно:

* База данных должна быть отказоустойчивой. Потребляет 4 ГБ ОЗУ в работе, 1 ядро. 3 копии.
* Кэш должен быть отказоустойчивый. Потребляет 4 ГБ ОЗУ в работе, 1 ядро. 3 копии.
* Фронтенд обрабатывает внешние запросы быстро, отдавая статику. Потребляет не более 50 МБ ОЗУ на каждый экземпляр, 0.2 ядра. 5 копий.
* Бекенд потребляет 600 МБ ОЗУ и по 1 ядру на копию. 10 копий.

## Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

План расчета
1. Сначала сделайте расчет всех необходимых ресурсов.
2. Затем прикиньте количество рабочих нод, которые справятся с такой нагрузкой.
3. Добавьте к полученным цифрам запас, который учитывает выход из строя как минимум одной ноды.
4. Добавьте служебные ресурсы к нодам. Помните, что для разных типов нод требовния к ресурсам разные.
5. Рассчитайте итоговые цифры.
6. В результате должно быть указано количество нод и их параметры.

## **Выполнение:**  

1. Расчет необходимых ресурсов.  
База данных: 4Гб, 1ЦПУ * 3 = 12Гб, 3ЦПУ  
Кэш: 4Гб, 1ЦПУ * 3 = 12Гб, 3ЦПУ  
Фронтэнд: 50Мб, 0,2ЦПУ * 5 = 0,25Гб, 1ЦПУ  
Бекэнд: 600Мб, 1ЦПУ * 10 = 6Гб, 10ЦПУ  
__Итого для кластера : 30,25Гб, 17ЦПУ__  
2. Количество рабочих нод, которые справятся с нагрузкой - 17 нод, по 2Гб и 1ЦПУ каждая.  
3. Добавляем запас для резервирования:  
Для БД и кэша +2 ноды, для фронта +1 и бэка +1.  
БД и кэш 8Гб, 2ЦПУ; фронт и бэк 2Гб 2ЦПУ;  
__в сумме запас 10Гб, 4ЦПУ,__ можно взять так: 2 ноды по 4Гб и 1ЦПУ + 2 ноды по 1Гб и 1ЦПУ.  
4. Служебные ресурсы для кластера:  
Мастер-ноды: 2Гб, 2ЦПУ * 3 = 6Гб, 6ЦПУ  
Воркер-ноды: 1Гб, 1ЦПУ * 3 = 3Гб, 3ЦПУ  
лог/мониторинг: 8Гб, 2ЦПУ * 1 = 8Гб, 2ЦПУ  
__Итого служебных ресурсов: 17 Гб, 11 ЦПУ__ : 3 ноды по 2Гб и 2ЦПУ + 3 ноды по 1Гб и 1ЦПУ + 1 нода 8Гб и 2ЦПУ  
5. Подсчитываем суммарные ресурсы:  
__Итого расчетно: 57,25Гб, 32ЦПУ__  
6. возможная конфигурация:  
28 нод:  
19 нод по 2Гб и 1ЦПУ;  
2 ноды по 4Гб и 1ЦПУ;  
3 ноды по 2Гб и 2ЦПУ;  
3 ноды по 1Гб и 1ЦПУ;  
1 нода 8Гб и 2ЦПУ  
Для удобства округлим до кратных стандартных значений: __64 Гб, 32ЦПУ__  