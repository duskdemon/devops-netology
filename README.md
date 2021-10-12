#devops-netology
# 06-db-02-sql
# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

**Ответ:**  

Забираем из докер-хаб 13 версию постгреса:
```
docker pull postgres:13
```
Создаем том:
```
docker volume create 6-4-psql
```
Запускаем контейнер:
```
docker run --rm --name=psql-13-1 -e POSTGRES_USER=user -e POSTGRES_PASSWORD=pass -p 5432:5432 -v 6-4-psql:/var/lib/postgresql postgres:13
```
Подключаемся в термина:
```
docker exec -ti psql-13-1 bash
```
подключаемся к постгрес:
```
root@c35406153608:/# psql -U user
psql (13.4 (Debian 13.4-4.pgdg110+1))
```
управляющие команды:
* вывода списка БД				\l
* подключения к БД				\c %DATABASENAME%
* вывода списка таблиц				\dtS
* вывода описания содержимого таблиц		\d %TABLENAME%
* выхода из psql				\q

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.  

**Ответ:**  
Кладем скачанный бэкап по пути C:\temp  
Запускаем контейнер с подмонтированным путем в том:
```
docker run --rm --name=psql-13-1 -e POSTGRES_USER=user -e POSTGRES_PASSWORD=pass -p 5432:5432 -v 6-4-psql:/var/lib/postgresql -v C:\temp:/var/lib/postgresql/bak postgres:13
```
Подключаемся в термина:
```
docker exec -ti psql-13-1 bash
```
Создаем базу:
```
user=# create database test_database;
CREATE DATABASE
```
Разворачиваем бэкап:
```
root@ddfd98e576b6:/var/lib/postgresql/bak# psql -U user -d test_database < /var/lib/postgresql/bak/test_dump.sql
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ERROR:  role "postgres" does not exist
CREATE SEQUENCE
ERROR:  role "postgres" does not exist
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
```
подключаемся к БД, проводим анализ и считаем наибольшее среднее значение:
```
user=# \c test_database
You are now connected to database "test_database" as user "user".
test_database=# \dt
        List of relations
 Schema |  Name  | Type  | Owner
--------+--------+-------+-------
 public | orders | table | user
(1 row)

test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
test_database=# select avg_width from pg_stats where tablename='orders';
 avg_width
-----------
         4
        16
         4
(3 rows)
```
## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?  
**Ответ:**  

Переименовываем изначальную таблицу и создаем новую с прежним именем:
```
test_database=# alter table orders rename to orders_orig;
ALTER TABLE
test_database=# create table orders (id integer, title varchar(80), price integer) partition by range(price);
CREATE TABLE
test_database=# create table orders_befor499 partition of orders for values from (0) to (499);
CREATE TABLE
test_database=# create table orders_after500 partition of orders for values from (499) to (999999);
CREATE TABLE
test_database=# insert into orders (id, title, price) select * from orders_orig;
INSERT 0 8
test_database=# select * from orders;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  2 | My little database   |   500
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
(8 rows)
```
Изначально при создании таблицы нужно было заложить шардирование таблицы.  

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?  
**Ответ:**  
Делаем бэкап:
```
root@ddfd98e576b6:/var/lib/postgresql/bak# pg_dump -U user -d test_database > /var/lib/postgresql/bak/test_db.sql
root@ddfd98e576b6:/var/lib/postgresql/bak# ls -al
total 2804
drwxrwxrwx 1 root     root        4096 Oct 12 19:29 .
drwxr-xr-x 4 postgres postgres    4096 Oct 12 19:01 ..
-rw-r--r-- 1 root     root        3500 Oct 12 19:29 test_db.sql
-rwxrwxrwx 1 root     root        2080 Oct 12 19:09 test_dump.sql
```
Чтобы добавить уникальность _title_ можно создать индекс по столбцу: CREATE INDEX ON orders ((lower(title)));
