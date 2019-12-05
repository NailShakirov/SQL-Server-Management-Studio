﻿USE  AdventureWorks2014



/* в серии уроков " работа с индексами"
-----------------------------------------------------*/


--рассмотрим некластиризованные несоставные индексы таблицы 'Person.Person'
select * from sys.indexes 
where object_id=OBJECT_ID('[Person].[Person]')
and  index_id>1
--такой есть AK_Person_rowguid, index_id=3
--select * from [Person].[Person] 
--это поле rowguid, cодержит значения 16 чные, не путайтесь


--используем системную табличную функцию 
--sys.dm_db_database_page_allocations
--найдем корневой узел, его айди страниц и айди файлов
select 
page_level
,allocated_page_file_id
,allocated_page_page_id
,*
from sys.dm_db_database_page_allocations(DB_ID(),OBJECT_ID('Person.Person'),3,null,'DETAILED')
order by 1 desc
--нашли, айди 12776


DBCC TRACEON(3604)

--рассмотрим содержимое страницы 
DBCC PAGE(AdventureWorks,1,11344,3) 
--содержит ссылки на дочерние страницы 65 штук
--ключи содержатся в поле rowguid - значения поля "rowguid"



--спустимся на листовой уровень
--страница 12745
DBCC PAGE(AdventureWorks,1,11316,3) 
--содержит значения поля  (rowguid) как ключи
--содержит значения поля BusinessEntityID, потому что это ключ класстерного индекса
--содержит Hash строк. Это хеш всех ключевых строк, не знаю какая хеш функция
--этот хеш не сохраняется в странице, а нужен для управления блокировками
--подробнее --https://social.msdn.microsoft.com/Forums/en-US/f39b0443-34f6-41b3-be1f-ea8e08c98ca5/dbcc-page-command?forum=sqlgetstarted 


--мы возьмем конкетное значение 0BA160A0-7CE3-4DCF-BF28-044E7ED363E6
--сначала найдет это значение в некластерном индексе и запомнить ключ в класстерном индексе
--далее по ключу определит все значения из класстерного индекса
--и так циклически для каждого значения rowguid 
select * from  Person.Person where rowguid='0BA160A0-7CE3-4DCF-BF28-044E7ED363E6'
-------посмотри план запроса

--Что будет если не было бы класстерного индекса


--создадим таблицу MyPersons
IF object_id('MyPersons') IS NOT NULL
			Begin
				Drop TABLE MyPersons
			END
ELSE 
			Begin
				Create Table MyPersons(
				ID int,
				Name nvarchar(100),
				LastName nvarchar(100),
				PersonType  nvarchar(2),
				)ON 'Primary'
			END	

--вставим данные
INSERT INTO MyPersons
select 
				 BusinessEntityID
				,FirstName  
				,LastName    
				,PersonType 
from Person.Person


--Создадим некластерный индекс на ID и всего лишь
CREATE INDEX NONCL_MyPersons_ID
ON MyPersons(ID)



--найдем корневой узел, его айди страниц и айди файлов для даннок индекса
select 
page_level
,allocated_page_file_id
,allocated_page_page_id
,*
from sys.dm_db_database_page_allocations(7,OBJECT_ID('MyPersons'),2,null,'DETAILED')
order by 1 desc
--айди страницы 55, айди файла 4


--исследуем корневую страницу
DBCC PAGE(AdventureWorks,1,23704,3) 
--содержит ссылки на дочерние страницы 45
--в качестве ключа значение поля (ID)
--содержит ссылки на строки 

--исследуем дочернюю страницу 88
--ID 609
--HEAP RID 0x3D5F000001007700
select * from MyPersons

DBCC PAGE(AdventureWorks,1,23497,3) 
--содержит сссылки на строки HEAP
--запомним значение ID =609,HEAP RID=0x3D5F000001007700, HASH=(d4e524d0ce42)
--заметим HEAP RID состоит из возьми байтов
--первые четыра байта перевернутые 00005F3D --номер страницы, это 24381
--следующие два байта перевернутые 0001 номер файла, это 1 
--0077 номер строки, это 119



--давайте узнаем на каких страницах находятся данные HEAP, параметр равен 0
select 
page_level
,allocated_page_file_id
,allocated_page_page_id
,*
from sys.dm_db_database_page_allocations(7,OBJECT_ID('MyPersons'),0,null,'DETAILED')
order by 1 desc

--посмотрим что хранится в страницах кучи
DBCC PAGE(AdventureWorks,1,23392,3) 
--искомое значение хранится на данной странице


