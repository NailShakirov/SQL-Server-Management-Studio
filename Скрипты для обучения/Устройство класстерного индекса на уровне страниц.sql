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







--рассмотрим таблицы которые устроены как кучи
select * from sys.dm_db_database_page_allocations(db_id(),
				NULL, NULL, NULL, 'DETAILED') 
select * from sys.objects
where object_id in (
				SELECT distinct object_id FROM sys.dm_db_database_page_allocations(db_id(),
				NULL, NULL, NULL, 'DETAILED') 
				where index_id=0
				)


--рассмотрим таблицы  у которых 3 слоя дерева, если такие есть конечно
select * from sys.objects
where object_id in (
				SELECT * FROM sys.dm_db_database_page_allocations(db_id(),
				NULL, NULL, NULL, 'DETAILED') 
 			where  page_level=2
				)

--одна из таких таблиц Person
select object_id('Person.Person')

--рассмотрим ее индексы
select * from sys.indexes where object_id=object_id('Person.Person')




--проверяем файлы БД, проверь на всяк через обозреватель объектов
SELECT distinct allocated_page_file_id FROM sys.dm_db_database_page_allocations(db_id(),
NULL, NULL, NULL, 'DETAILED')


--проверяем какие объектсы содержатся в страницах, можно заметить что среди них есть и представленияб значит скорее всего
--для них были созданы индексы
select * from sys.objects
where object_id in (
				SELECT distinct object_id FROM sys.dm_db_database_page_allocations(db_id(),
				NULL, NULL, NULL, 'DETAILED')
				)

				

--рассмотрим таблицы которые устроены как кучи
select * from sys.objects
where object_id in (
				SELECT distinct object_id FROM sys.dm_db_database_page_allocations(db_id(),
				NULL, NULL, NULL, 'DETAILED') 
				where index_id=0
				)

--рассмотрим таблицы  у которых 3 слоя дерева 
select * from sys.objects
where object_id in (
				SELECT distinct object_id FROM sys.dm_db_database_page_allocations(db_id(),
				NULL, NULL, NULL, 'DETAILED') 
 			where  page_level=2
				)

				select * from Person.Person where BusinessEntityID=80
--нашли одну из таблиц, у нее класетризованный индексб найдем корневой узел и проверим
select object_id('Person.Person')
select *  FROM sys.dm_db_database_page_allocations(db_id(),
				object_id('Person.Person'), NULL, NULL, 'DETAILED') 
				where page_level=3 and index_id=1


--содержит айди дочерних страниц и ключи 
DBCC PAGE(AdventureWorks2014,1,903,3) --with  TABLERESULTS

DBCC PAGE(AdventureWorks2014,1,903,2)--with  TABLERESULTS
select CONVERT(VarBinary(MAX), 'парр')
select convert(varchar(max),0x09ea0500710000138713260a0100c817a8040000)
SELECT 
  CONVERT ( varbinary (64), 0x06010000 ),
   C



select * from sys.dm_db_index_physical_stats(db_id(),	object_id('Person.Person'),NULL,NULL, 'Detailed')
where index_id=1
select * from MyClients

sp_help 'MyClients'

SELECT CONVERT(varchar, 0x16000093) 
SELECT CONVERT(varchar(100), 0x01020002)



select * from sys.indexes where object_id=object_id('MyClients')
select * from sys.dm_db_index_physical_stats(db_id(),object_id('MyClients'),NULL,NULL, 'Detailed')
SELECT distinct allocated_page_file_id FROM sys.dm_db_database_page_allocations(db_id('AdventureWorks2014'),
object_id('MyClients'), NULL, NULL, 'DETAILED')
WHERE page_type = 1;

 DBCC TRACEON(3604)


	select * from sys.dm_db_page_info (7, NULL, NULL, 'DETAILED')

	--фунция для просмотра страниц данного объекта
 DBCC IND(AdventureWorks2014,'Person.Person',-1) 



	DBCC PAGE(AdventureWorks2014,5,16,1) --with  TABLERESULTS






	SELECT * FROM sys.dm_db_database_page_allocations(db_id('AdventureWorks2014'),
NULl, NULL, NULL, 'DETAILED') where page_type=10