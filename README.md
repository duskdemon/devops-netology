#devops-netology
# 06-db-02-sql
## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.
**Ответ:**

Забираем из докер-хаба образ postgresql:  
```
docker pull postgresql:12  
```
создаем 2 тома:  
```
docker volume create 6-2-sql-0  
docker volume create 6-2-sql-1  
```
Запускаем контейнер, монтируем тома:  
```
docker run -name=psql-12-1 -ti -e POSTGRES_USER=user -e POSTGRES_PASSWORD=pass -p 5432:5432 -v 6-2-sql-0:/var/lib/postgresql -v 6-2-sql-1:/var/lib/postgresql/data 
postgres:12
```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db  

**Ответ:**  
root@44a279e4af7e:/# createuser test-admin-user -U user
root@44a279e4af7e:/# createuser test-simple-user -U user
root@44a279e4af7e:/# createdb -U user test_db

CREATE TABLE orders(
	id	serial PRIMARY KEY,
	ordername	varchar(24) NOT NULL,
	price	integer NOT NULL
	);
	
CREATE TABLE clients(
	id	integer PRIMARY KEY,
	lastname	varchar(24) NOT NULL,
	country	varchar(24) NOT NULL,
    ord integer REFERENCES orders(id)
	);

CREATE INDEX order_index ON clients (ord);

grant all on orders to "test-admin-user";
grant all on clients to "test-admin-user";
grant SELECT,INSERT,UPDATE,DELETE on orders to "test-simple-user";
grant SELECT,INSERT,UPDATE,DELETE on clients to "test-simple-user";
```
test_db=# \l
                             List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges
-----------+-------+----------+------------+------------+-------------------
 postgres  | user  | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | user  | UTF8     | en_US.utf8 | en_US.utf8 | =c/user          +
           |       |          |            |            | user=CTc/user
 template1 | user  | UTF8     | en_US.utf8 | en_US.utf8 | =c/user          +
           |       |          |            |            | user=CTc/user
 test_db   | user  | UTF8     | en_US.utf8 | en_US.utf8 |
 user      | user  | UTF8     | en_US.utf8 | en_US.utf8 |
(5 rows)
```
```
test_db=# \d orders
                                     Table "public.orders"
  Column   |         Type          | Collation | Nullable |              Default
-----------+-----------------------+-----------+----------+------------------------------------
 id        | integer               |           | not null | nextval('orders_id_seq'::regclass)
 ordername | character varying(24) |           | not null |
 price     | integer               |           | not null |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_ord_fkey" FOREIGN KEY (ord) REFERENCES orders(id)
```
```
test_db=# \d clients
                      Table "public.clients"
  Column  |         Type          | Collation | Nullable | Default
----------+-----------------------+-----------+----------+---------
 id       | integer               |           | not null |
 lastname | character varying(24) |           | not null |
 country  | character varying(24) |           | not null |
 ord      | integer               |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "order_index" btree (ord)
Foreign-key constraints:
    "clients_ord_fkey" FOREIGN KEY (ord) REFERENCES orders(id)
```
```
test_db=# SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_name='orders';
     grantee      | privilege_type
------------------+----------------
 user             | INSERT
 user             | SELECT
 user             | UPDATE
 user             | DELETE
 user             | TRUNCATE
 user             | REFERENCES
 user             | TRIGGER
 test-admin-user  | INSERT
 test-admin-user  | SELECT
 test-admin-user  | UPDATE
 test-admin-user  | DELETE
 test-admin-user  | TRUNCATE
 test-admin-user  | REFERENCES
 test-admin-user  | TRIGGER
 test-simple-user | INSERT
 test-simple-user | SELECT
 test-simple-user | UPDATE
 test-simple-user | DELETE
(18 rows)
```
```
test_db=# SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_name='clients';
     grantee      | privilege_type
------------------+----------------
 user             | INSERT
 user             | SELECT
 user             | UPDATE
 user             | DELETE
 user             | TRUNCATE
 user             | REFERENCES
 user             | TRIGGER
 test-admin-user  | INSERT
 test-admin-user  | SELECT
 test-admin-user  | UPDATE
 test-admin-user  | DELETE
 test-admin-user  | TRUNCATE
 test-admin-user  | REFERENCES
 test-admin-user  | TRIGGER
 test-simple-user | INSERT
 test-simple-user | SELECT
 test-simple-user | UPDATE
 test-simple-user | DELETE
(18 rows)
```
## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

**Ответ:**
```
test_db=# insert into orders VALUES (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор', 7000), (5, 'Гитара', 4000);
INSERT 0 5
test_db=# insert into clients VALUES (1, 'Иванов Иван Иванович', 'США'), (2,'Петров Петр Петрович', 'Канада'), (3,'Иоганн Себастьян Бах','Япония'), (4, 'Ронни Джеймс Дио', 'Россия'), (5,'Ritchie Blackmore', 'Россия');
INSERT 0 5
```
```
test_db=# select count (*) from orders;
 count
-------
     5
(1 row)

test_db=# select count (*) from clients;
 count
-------
     5
(1 row)
```


## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

**Ответ:**
```
test_db=# update  clients set ord = 3 where id = 1;
UPDATE 1
test_db=# update  clients set ord = 4 where id = 2;
UPDATE 1
test_db=# update  clients set ord = 5 where id = 3;
UPDATE 1
```
```
test_db=# select * from clients where ord is not NULL;
 id |       lastname       | country | ord
----+----------------------+---------+-----
  1 | Иванов Иван Иванович | США     |   3
  2 | Петров Петр Петрович | Канада  |   4
  3 | Иоганн Себастьян Бах | Япония  |   5
(3 rows)
```
## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.
**Ответ:**

```
test_db=# explain select * from clients where ord is not null;
                         QUERY PLAN
------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..14.80 rows=478 width=140)
   Filter: (ord IS NOT NULL)
(2 rows)
```
получаем статистику запроса - время для отработки и число обработанных запросом строк.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 
**Ответ:**
делаем дамп базы:
```
root@44a279e4af7e:/# pg_dump -U user test_db > /var/lib/postgresql/test_db_dump.sql
root@44a279e4af7e:/# ls -la /var/lib/postgresql/
total 16
drwxr-xr-x  3 postgres postgres 4096 Sep 30 19:02 .
drwxr-xr-x  1 root     root     4096 Sep 23 23:56 ..
drwx------ 19 postgres postgres 4096 Sep 30 17:37 data
-rw-r--r--  1 root     root     3367 Sep 30 19:02 test_db_dump.sql
```

поднимаем новый контейнер с postgresql:
```
docker run --name=psql-12-2 -ti -e POSTGRES_USER=user -e POSTGRES_PASSWORD=pass -v 6-2-sql-0:/var/lib/postgresql postgres:12
```
заходим в контейнер, находим файл дампа базы:
```
PS C:\Users\DuskDemon> docker exec -it psql-12-2 bash
root@d80104bd4825:/# cd /var/lib/postgresql/
root@d80104bd4825:/var/lib/postgresql# ls -al
total 16
drwxr-xr-x  3 postgres postgres 4096 Sep 30 19:02 .
drwxr-xr-x  1 root     root     4096 Sep 23 23:56 ..
drwx------ 19 postgres postgres 4096 Sep 30 19:08 data
-rw-r--r--  1 root     root     3367 Sep 30 19:02 test_db_dump.sql
```
делаем восствновление, предварительно создав одноимменную базу:
```
root@d80104bd4825:/var/lib/postgresql# psql -U user
psql (12.8 (Debian 12.8-1.pgdg110+1))
Type "help" for help.

user=# create database test_db;
CREATE DATABASE
user=# \q
root@d80104bd4825:/var/lib/postgresql# psql -U user -d test_db < /var/lib/postgresql/test_db_dump.sql
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
ALTER TABLE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 5
COPY 5
 setval
--------
      1
(1 row)

ALTER TABLE
ALTER TABLE
CREATE INDEX
ALTER TABLE
ERROR:  role "test-admin-user" does not exist
ERROR:  role "test-simple-user" does not exist
root@d80104bd4825:/var/lib/postgresql# psql -U user
psql (12.8 (Debian 12.8-1.pgdg110+1))
Type "help" for help.

user=# \l
                             List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges
-----------+-------+----------+------------+------------+-------------------
 postgres  | user  | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | user  | UTF8     | en_US.utf8 | en_US.utf8 | =c/user          +
           |       |          |            |            | user=CTc/user
 template1 | user  | UTF8     | en_US.utf8 | en_US.utf8 | =c/user          +
           |       |          |            |            | user=CTc/user
 test_db   | user  | UTF8     | en_US.utf8 | en_US.utf8 |
 user      | user  | UTF8     | en_US.utf8 | en_US.utf8 |
(5 rows)

user=#
```
