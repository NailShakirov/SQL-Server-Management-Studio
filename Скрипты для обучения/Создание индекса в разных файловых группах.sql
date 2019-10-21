USE AdventureWorks2014


--Добавим новый файл в существующую файловую группу
ALTER DATABASE AdventureWorks2014
ADD FILE 
(NAME='Second_on_primary',
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\Second_on_primary.mdf',  
SIZE = 20MB,  
MAXSIZE = 25MB,  
FILEGROWTH = 5MB )

--Добавим еще один файл в существующую файловую группу с другим расширением
ALTER DATABASE AdventureWorks2014
ADD FILE 
(NAME='Third_on_primary',
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\Third.ndf',  
SIZE = 20MB,  
MAXSIZE = 25MB,  
FILEGROWTH = 5MB )


--Добавим  файловую группу и пару файлов  в ней
ALTER DATABASE AdventureWorks2014
ADD FILEGROUP Second


ALTER DATABASE AdventureWorks2014
ADD FILE 
(NAME='FIRST_on_Second',
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\FIRST_on_Second.ndf',  
SIZE = 20MB,  
MAXSIZE = 25MB,  
FILEGROWTH = 5MB ),

(NAME='second_on_Second',
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\second_on_Second.ndf',  
SIZE = 20MB,  
MAXSIZE = 25MB,  
FILEGROWTH = 5MB )
to FILEGROUP Second




--туперь мы создаем таблицу в первой файловй группе
IF object_id('MyClients') IS NOT NULL
			Begin
				Drop TABLE MyClients
			END
ELSE 
			Begin
				Create Table MyClients(
				ID int,
				Name nvarchar(100),
				LastName nvarchar(100),
				PersonType  nvarchar(2),
				)ON 'Primary'
			END	

--определить  файловую группу где лежит таблица можно узнать с помощью:
sp_help 'MyClients'

--заполним данными 
INSERT INTO MyClients
select 
				 BusinessEntityID
				,FirstName  
				,LastName    
				,PersonType 
from Person.Person

--теперь создадим некластеризованный индекс для этой таблицы только в другой файловой группе
--drop INDEx  NONCL_MyClients_Name ON MyClients
CREATE  INDEX NONCL_MyClients_Name
ON MyClients(Name)
ON SECOND

--смотрим план запроса
select PersonType from MyClients 
With  (index(NONCL_MyClients_Name))
where Name='Dylan' 

--удалим это индекс
drop INDEx  NONCL_MyClients_Name ON MyClients

--теперь создадим индекс только с включением столбца PersonType, так называемый покрывающий индекс
CREATE  INDEX NONCL_MyClients_Name
ON MyClients(Name)
INCLUDE(PersonType)
ON SECOND


--смотрим теперь план запроса, сравникивем и понмаем что  теперь нет loop
select PersonType from MyClients 
With  (index(NONCL_MyClients_Name))
where Name='Dylan' 







