
USE master ;  
GO  

Drop DATABASE Sales


--создаем базу данных  Sales
CREATE DATABASE Sales  
ON   
( NAME = Sales_dat,  --логмческое имя файла, должно быть уникальным в пределах сервера
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\saledat.mdf', --полное имя файла
    SIZE = 5,  --начальный размер, файл mdf занимает минимум 5 мб.Этот параметр сразу резеривует память на жестком диске
    MAXSIZE = 5, --максимальный размер в мегабайтах. Если tun привысить система ругнется
    FILEGROWTH = 1 )  -- нижняя граница инкремента для автоматического  роста файла для будущего заполнения данными; должен быть меньше MAXSIZE
LOG ON  --файл для лога
( NAME = Sales_log,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\salelog.ldf',  
    SIZE = 5MB,  
    MAXSIZE = 25MB,  
    FILEGROWTH = 5MB ) ;  
GO  


USE SALES
CREATE TABLE Person (
 ID int
,Name nvarchar(100)
)

select * from Person
INSERT Person
select [BusinessEntityID],[FirstName]from [AdventureWorks2014].[Person].[Person]




--создаем базу данных  MyDB на нескольких файловых группах



CREATE DATABASE MyDB
ON PRIMARY --файловая гурппа по умолчаниюб так называемая первичная. Содержит всю системную информацию и другую
  ( NAME='MyDB_Primary',
    FILENAME=
       'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\MyDB_Prm.mdf',
    SIZE=4MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB),
FILEGROUP MyDB_FG1  -- другая файловая группа содержит пользовательскую информацию в файлах ndf 
  ( NAME = 'MyDB_FG1_Dat1',
    FILENAME =
       'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\MyDB_FG1_1.ndf',
    SIZE = 1MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB),
  ( NAME = 'MyDB_FG1_Dat2',
    FILENAME =
       'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\MyDB_FG1_2.ndf',
    SIZE = 1MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB),
FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM --создаем файловую группу типа FILESTREAM
  ( NAME = 'MyDB_FG_FS',
    FILENAME = 'c:\Data\filestream1')
LOG ON
  ( NAME='MyDB_log',
    FILENAME =
       'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\MyDB.ldf',
    SIZE=1MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB);


--изменяем файловую группу на "по умолчанию". Тогда на первичной файловой группе будет храниться 
--ТОЛЬКО системная инфа, а не пользовательская
ALTER DATABASE MyDB 
  MODIFY FILEGROUP MyDB_FG1 DEFAULT;
GO



--создаем таблицу в пользовательской  файловой группе MyDB_FG1. Получается данные  таблицы заполняются равномерно по файлам
--MyDB_FG1_1.ndf и MyDB_FG1_2.ndf
USE MyDB;
CREATE TABLE MyTable
  ( cola int PRIMARY KEY,
    colb char(8) )
ON MyDB_FG1;
GO

-- создаем таблицу в файловой группе файл стрим
CREATE TABLE MyFSTable
(
    cola int PRIMARY KEY,
  colb VARBINARY(MAX) FILESTREAM NULL
)
GO



sp_helpdb MYBase


Status=ONLINE, Updateability=READ_WRITE, UserAccess=MULTI_USER, Recovery=SIMPLE, Version=782, Collation=Cyrillic_General_CI_AS, SQLSortOrder=0, IsAutoClose, IsAutoCreateStatistics, IsAutoUpdateStatistics, IsFullTextEnabled

select * from sys.databases