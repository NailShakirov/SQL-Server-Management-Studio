
USE master ;  
GO  

Drop DATABASE Sales


--������� ���� ������  Sales
CREATE DATABASE Sales  
ON   
( NAME = Sales_dat,  --���������� ��� �����, ������ ���� ���������� � �������� �������
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\saledat.mdf', --������ ��� �����
    SIZE = 5,  --��������� ������, ���� mdf �������� ������� 5 ��.���� �������� ����� ���������� ������ �� ������� �����
    MAXSIZE = 5, --������������ ������ � ����������. ���� tun ��������� ������� ��������
    FILEGROWTH = 1 )  -- ������ ������� ���������� ��� ���������������  ����� ����� ��� �������� ���������� �������; ������ ���� ������ MAXSIZE
LOG ON  --���� ��� ����
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




--������� ���� ������  MyDB �� ���������� �������� �������



CREATE DATABASE MyDB
ON PRIMARY --�������� ������ �� ���������� ��� ���������� ���������. �������� ��� ��������� ���������� � ������
  ( NAME='MyDB_Primary',
    FILENAME=
       'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\MyDB_Prm.mdf',
    SIZE=4MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB),
FILEGROUP MyDB_FG1  -- ������ �������� ������ �������� ���������������� ���������� � ������ ndf 
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
FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM --������� �������� ������ ���� FILESTREAM
  ( NAME = 'MyDB_FG_FS',
    FILENAME = 'c:\Data\filestream1')
LOG ON
  ( NAME='MyDB_log',
    FILENAME =
       'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\MyDB.ldf',
    SIZE=1MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB);


--�������� �������� ������ �� "�� ���������". ����� �� ��������� �������� ������ ����� ��������� 
--������ ��������� ����, � �� ����������������
ALTER DATABASE MyDB 
  MODIFY FILEGROUP MyDB_FG1 DEFAULT;
GO



--������� ������� � ����������������  �������� ������ MyDB_FG1. ���������� ������  ������� ����������� ���������� �� ������
--MyDB_FG1_1.ndf � MyDB_FG1_2.ndf
USE MyDB;
CREATE TABLE MyTable
  ( cola int PRIMARY KEY,
    colb char(8) )
ON MyDB_FG1;
GO

-- ������� ������� � �������� ������ ���� �����
CREATE TABLE MyFSTable
(
    cola int PRIMARY KEY,
  colb VARBINARY(MAX) FILESTREAM NULL
)
GO



sp_helpdb MYBase


Status=ONLINE, Updateability=READ_WRITE, UserAccess=MULTI_USER, Recovery=SIMPLE, Version=782, Collation=Cyrillic_General_CI_AS, SQLSortOrder=0, IsAutoClose, IsAutoCreateStatistics, IsAutoUpdateStatistics, IsFullTextEnabled

select * from sys.databases