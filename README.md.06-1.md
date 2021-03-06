#devops-netology
### 06-db-01-basics
#### Задача 1
Архитектор ПО решил проконсультироваться у вас, какой тип БД лучше выбрать для хранения определенных данных.
Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:
* Электронные чеки в json виде
* Склады и автомобильные дороги для логистической компании
* Генеалогические деревья
* Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации
* Отношения клиент-покупка для интернет-магазина
Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.  
**Ответ**
* _Электронные чеки в json виде_  
Электронный чек - документ, в этом случае подойдет документо-ориентированный тип БД.  
* _Склады и автомобильные дороги для логистической компании_  
В этом случае подойдет классическая реляционная БД, например SQL-типа  
* _Генеалогические деревья_  
В этом случае подходит БД сетевого типа, т.к. она подходит для хранения связей  между объектами вида "родитель-потомок"  
* _Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации_  
Поскольку речь идет о системе аутентификации, важным является аспект безопасности. Требуется задать время существования данных (time to live), необходимым функционалом обладают СУБД Redis и memcached. Можно использовать одну из них.  
* _Отношения клиент-покупка для интернет-магазина_  
Можно выбрать cиcтему типа key-value, как подходящие для реализации взаимосвязи отношений клиент-товар. 
#### Задача 2
Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если (каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):
Данные записываются на все узлы с задержкой до часа (асинхронная запись)
При сетевых сбоях, система может разделиться на 2 раздельных кластера
Система может не прислать корректный ответ или сбросить соединение
А согласно PACELC-теореме, как бы вы классифицировали данные реализации?  
**Ответ**  
_Данные записываются на все узлы с задержкой до часа (асинхронная запись)_  
По CAP: CP; По PACELC: PA/EL  
_При сетевых сбоях, система может разделиться на 2 раздельных кластера_  
По CAP: AP; По PACELC: PA/EC  
_Система может не прислать корректный ответ или сбросить соединение_  
По CAP: CA; По PACELC: EC/PC  
#### Задача 3
Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?  
**Ответ**  
Отдельные требования принципов ACID и BASE могут сочетаться в системе. Но, поскольку эти принципы нацелены на разные свойства (первый - надежность, второй - производительность), нельзя одновременно хорошо реализовать их все в одной системе, т.к. некоторые требования противоречат друг другу. Всегда будет перекос в какую-либо сторону.  
#### Задача 4
Вам дали задачу написать системное решение, основой которого бы послужили:
* фиксация некоторых значений с временем жизни
* реакция на истечение таймаута  
Вы слышали о key-value хранилище, которое имеет механизм Pub/Sub. Что это за система? Какие минусы выбора данной системы?  
**Ответ**  
Key-value хранилище с механизмом Pub/Sub - это Redis. Минус - нехватка автоматического механизма обеспечения отказоустойчивости. Можно использовать Redis sentinel, в составе которой есть необходимый механизм выбора ведущего узла.
