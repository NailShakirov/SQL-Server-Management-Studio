USE AdventureWorks2014


--������� ����� ���� � ������������ �������� ������
ALTER DATABASE AdventureWorks2014
ADD FILE 
(NAME='Second_on_primary',
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\Second_on_primary.mdf',  
SIZE = 20MB,  
MAXSIZE = 25MB,  
FILEGROWTH = 5MB )

--������� ��� ���� ���� � ������������ �������� ������ � ������ �����������
ALTER DATABASE AdventureWorks2014
ADD FILE 
(NAME='Third_on_primary',
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\Third.ndf',  
SIZE = 20MB,  
MAXSIZE = 25MB,  
FILEGROWTH = 5MB )


--�������  �������� ������ � ���� ������  � ���
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




--������ �� ������� ������� � ������ ������� ������
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

--����������  �������� ������ ��� ����� ������� ����� ������ � �������:
sp_help 'MyClients'

--�������� ������� 
INSERT INTO MyClients
select 
				 BusinessEntityID
				,FirstName  
				,LastName    
				,PersonType 
from Person.Person

--������ �������� ������������������ ������ ��� ���� ������� ������ � ������ �������� ������
--drop INDEx  NONCL_MyClients_Name ON MyClients
CREATE  INDEX NONCL_MyClients_Name
ON MyClients(Name)
ON SECOND

--������� ���� �������
select PersonType from MyClients 
With  (index(NONCL_MyClients_Name))
where Name='Dylan' 

--������ ��� ������
drop INDEx  NONCL_MyClients_Name ON MyClients

--������ �������� ������ ������ � ���������� ������� PersonType, ��� ���������� ����������� ������
CREATE  INDEX NONCL_MyClients_Name
ON MyClients(Name)
INCLUDE(PersonType)
ON SECOND


--������� ������ ���� �������, ����������� � ������� ���  ������ ��� loop
select PersonType from MyClients 
With  (index(NONCL_MyClients_Name))
where Name='Dylan' 







