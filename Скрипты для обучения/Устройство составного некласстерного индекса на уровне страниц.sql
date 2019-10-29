USE  AdventureWorks2014



/* в серии уроков " работа с индексами"
-----------------------------------------------------*/


--рассмотрим как утроен составной некласстерный индекс

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
GO 


--создадим неклассерный составной индекс
CREATE  NONClUSTERED INDEX CL_MyChildren_Name_LastName
ON MyChildren(NAME,LASTNAME)


--посмотрим план запроса с учетом только первого поля
select * from MyChildren where Name='Abby'
--использует seek в некласстеризованном индексе


--посмотрим план запроса с учетом только второго поля
select * from MyChildren where LastName='Allen'
--использует scan в куче

--посмотрим план запроса с учетом обоих полей
select * from MyChildren where Name='Abby' and LastName='Allen'
--использует seek в некласстеризованном индекс



--используем системную табличную функцию 
--sys.dm_db_database_page_allocations
--найдем корневой узел, его айди страниц и айди файлов некласстерного индекса
select 
page_level
,allocated_page_file_id
,allocated_page_page_id
,*
from sys.dm_db_database_page_allocations(7,OBJECT_ID('MyChildren'),2,null,'DETAILED')
order by 1 desc
--нашли, айди 24848 , айди файла 1


DBCC TRACEON(3604)
--посмотрим структуру страницы корневного узла
DBCC PAGE(AdventureWorks2014,1,24848,3) 
--содержит ссылкы на дочерние страницы
--ключ это поля указанные в индексе+содержит номер строки в бд для кучи
--что дает уникальность
--рассмотрим дочернюю страницу  496 , файл айди 3


DBCC PAGE(AdventureWorks2014,3,497,3) 
--ключ это поля указанные в индексе + номер строки в бд для кучи (HEAP READ)
--интересно заметить что ключ одного узла (k_1,k_2)
--меньше ключа друго (n_1,n_2)
--если  (k1<n1) или (k1=n1 и k2<n2)




--выходит что порядок столбцов в индексе имеет значение