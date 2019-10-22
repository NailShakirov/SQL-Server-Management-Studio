USE AdventureWorks2014



/* из серии уроков "работа с индесами"
-------------------------------------------------*/



--рассмотрим как утроен составной класстерный индекс

--создадим таблицу
IF object_id('MyChildren') IS NOT NULL
			Begin
				Drop TABLE MyChildren
			END
ELSE 
			Begin
				Create Table MyChildren(
				ID int,
				Name nvarchar(100),
				LastName nvarchar(100),
				PersonType  nvarchar(2),
				)ON 'Primary'
			END	

--вставим данные
INSERT INTO MyChildren
select 
				 BusinessEntityID
				,FirstName  
				,LastName    
				,PersonType 
from Person.Person


--select * from c

--создадим классерный составной индекс
CREATE  ClUSTERED INDEX CL_MyChildren_Name_LastName
ON MyChildren(NAME,LASTNAME)

--теперь наши данные отсортированы
select * from MyChildren


--посмотрим план запроса с учетом только первого поля
select * from MyChildren where Name='Abby'
--использует seek в класстеризованном индексе


--посмотрим план запроса с учетом только второго поля
select * from MyChildren where LastName='Allen'
--использует scan в класстеризованном индекс


--посмотрим план запроса с учетом обоих полей
select * from MyChildren where Name='Abby' and LastName='Allen'
--использует seek в класстеризованном индекс


--используем системную табличную функцию 
--sys.dm_db_database_page_allocations
--найдем корневой узел, его айди страниц и айди файлов клаасстерного индекса
select 
page_level
,allocated_page_file_id
,allocated_page_page_id
,*
from sys.dm_db_database_page_allocations(7,OBJECT_ID('MyChildren'),1,null,'DETAILED')
order by 1 desc
--нашли, айди 320 , айди файла 4

DBCC TRACEON(3604)
--посмотрим структуру страницы корневного узла
DBCC PAGE(AdventureWorks2014,4,320,3) 
--содержит ссылкы на дочерние страницы
--ключ это поля указанные в индексе + порядковый номер данного набора
--что дает уникальность




--рассмотрим струкутру дочерней страницы
DBCC PAGE(AdventureWorks2014,1,24689,3) 
