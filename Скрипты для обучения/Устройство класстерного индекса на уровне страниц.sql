USE AdventureWorks2014

/*В серии уроков "работа с индексами"
---------------------------------------------------------------*/
--Существет так называемая табличная функция 
--sys.dm_db_database_page_allocations(db id , id table or null(all), index or null (all), 'LIMITED' or 'DETAILED')
--эта функция показывает как объекты хранят информацию на страницах и где эти страницы размещаются
--Параметры: айди бд, aйди таблицы (если null то все), айди индекса , раздел , режим


--рассмотрим таблицу 'MyClients'
select * from sys.dm_db_database_page_allocations(7,OBJECT_ID('MyClients'),null,null,'DETAILED')

--0 index_id означает что это куча
--1 index_id класстерированный
-->1 index_id некласстерированный

--рассмотрим таблицу 'Person.Person'
select * from sys.dm_db_database_page_allocations(7,OBJECT_ID('Person.Person'),null,null,'DETAILED')
--видим что есть класстеризованный индекс

--выгрузим все айди страниц на которых расположен этот кластерный индекс
select allocated_page_page_id,index_id,* from sys.dm_db_database_page_allocations(7,OBJECT_ID('Person.Person'),null,null,'DETAILED')
where index_id=1


--тут есть поле  page_level
--0 листовой узел
--max корневой узел
select 
 allocated_page_page_id
,index_id
,page_level
,* from sys.dm_db_database_page_allocations(7,OBJECT_ID('Person.Person'),null,null,'DETAILED')
where index_id=1
order by 3 desc
--видим что корневой узел расположен на 903 странице

--узнаем айди файлов на котором расположен класстеризованный индекс
select 
 allocated_page_file_id
,allocated_page_page_id
,index_id
,page_level
,* from sys.dm_db_database_page_allocations(7,OBJECT_ID('Person.Person'),null,null,'DETAILED')
where index_id=1
order by 4 desc


--давайте рассмотрим содержимое этой страницы 
--с помощью DBCC PAGE()
--показывает содержимое страницы 
--параметры:Бд,айди файла, айди страницы, режим(0 только HEader,1-краткий,2-подробный но в виде blob,3 -подробный интерпретированный) 


DBCC TRACEON(3604)
DBCC PAGE(AdventureWorks2014,1,903,2) --with  TABLERESULTS
--Page Header содержит поля m_prevPage,m_nextPage = (0:0) ссылки на предыдущие, следующие страницы
--можно заметить что после Data указаны Memory Dump
--Тут идут номера адресов памяти (которая кстати меняется со временм) и соостветвующая двоичная инфа которая там хранится
--тут хранится все информация от типе данных, сами данные. Null или нет, индексная запись это или нет. В общемм всю информацию
--расшифровку можно смотреть тут  https://www.sql.ru/articles/mssql/2007/011004dbccpagepart1.shtml
--В Offset Table У каждого значения есть Offset- номера строк табллицы  от конца Page Header
--надо сказать что строка записи таблицы может размещеаться на нескольких строках страницы  

DBCC PAGE(AdventureWorks2014,1,903,3) --with  TABLERESULTS
--указаны только  ключевые значения BusinessEntityID и ссылки на дочерние страницы
--эта страница сожержит 8 дочерних страниц
--заметьте данных нет, только ключи и ссылки на дочерние страницы
--возьмем дочернюю страниwe 919, спустимся на уровень ниже

DBCC PAGE(AdventureWorks2014,1,919,2) 
--в Page Header написано что предыдущая страница 1504, следующая 915

DBCC PAGE(AdventureWorks2014,1,919,3) 
--данная страница содержит уже 501 дочерних страниц 
--возьмем 1441 сраницу

DBCC PAGE(AdventureWorks2014,1,1441,3) 
--это уже листовой узел
--здесь уже видны значения всех колонок таблицы
--ссылки на предыдущая страница 1440, следующая 1442
--cодержится двоичная информация
--содержится все строки Slots, и интерпретация по каждому Column
--данная страница содержит 5 строк (0-4 Slots) и 13 Columns
--у каждой строки есть свой номер Offset от начала страницы после Header
--у каждой строки есть своя длина Length в байтах
--у каждой строки есть Hash
--в Header указано что кол-во свободного места m_freeCnt=1184.


--давайте узнаем количество страниц отведенных на данный индекс
--табличная функция sys.dm_db_index_physical_stats
--Параметры: айди бд, aйди таблицы (если null то все), айди индекса , раздел , режим
select * from sys.dm_db_index_physical_stats(db_id(),	object_id('Person.Person'),NULL,NULL, 'Detailed')
where index_id=1


--рассмотрим узлы этого дерева
select 
 fragment_count
,* 
from sys.dm_db_index_physical_stats(db_id(),	object_id('Person.Person'),NULL,NULL, 'Detailed')
where index_id=1
--видим что 1,2,136

--рассмотрим общее количесвто страниц на всех уровнях узлах и записей
select 
 fragment_count
,index_level
,page_count
,record_count
,*
from sys.dm_db_index_physical_stats(db_id(),	object_id('Person.Person'),NULL,NULL, 'Detailed')
where index_id=1
-- 8, 3809,19972 записей





--Создадим таблицу с класстерным индексом
--что будет если мы удалим половину строу
--как изменится инфа на страницах 

--создадим таблицу
IF object_id('Table1') IS NOT NULL
			Begin
				Drop TABLE Table1
			END
ELSE 
			Begin
				Create Table Table1(
				ID int,
				Name nvarchar(100),
				LastName nvarchar(100),
				PersonType  nvarchar(2),
				)ON 'Primary'
			END	

--вставим данные
INSERT INTO Table1
select 
				 BusinessEntityID
				,FirstName  
				,LastName    
				,PersonType 
from Person.Person
GO 


--создадим классерный  индекс
CREATE  ClUSTERED INDEX CL_Table1_ID
ON Table1(ID)

--найдем корневой узел
select
 allocated_page_file_id 
,allocated_page_page_id
,index_id
,page_level
,* from sys.dm_db_database_page_allocations(7,OBJECT_ID('Table1'),null,null,'DETAILED')
where index_id=1
order by 4 desc
--688 cтраница, 3 файл


--исследуем корневой узел
DBCC TRACEON(3604)
DBCC PAGE(AdventureWorks2014,3,688,3)
--возьмем 659 дочернюю страницу, 4 файл


DBCC PAGE(AdventureWorks2014,4,659,3)
--возьмем 96 строку ID = 849 



--Теперь удалим половину строк из Table1
DELETE  from Table1
where ID<9800
 
	
--Перейдем  опять на 659 страницу
DBCC PAGE(AdventureWorks2014,4,659,3)
--прежних записей уже нет 




