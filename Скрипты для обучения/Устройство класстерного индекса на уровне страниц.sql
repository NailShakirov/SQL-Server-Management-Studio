USE AdventureWorks2014

/*� ����� ������ "������ � ���������"
---------------------------------------------------------------*/
--��������� ��� ���������� ��������� ������� 
--sys.dm_db_database_page_allocations(db id , id table or null(all), index or null (all), 'LIMITED' or 'DETAILED')
--��� ������� ���������� ��� ������� ������ ���������� �� ��������� � ��� ��� �������� �����������
--���������: ���� ��, a��� ������� (���� null �� ���), ���� ������� , ������ , �����


--���������� ������� 'MyClients'
select * from sys.dm_db_database_page_allocations(7,OBJECT_ID('MyClients'),null,null,'DETAILED')

--0 index_id �������� ��� ��� ����
--1 index_id �����������������
-->1 index_id �������������������

--���������� ������� 'Person.Person'
select * from sys.dm_db_database_page_allocations(7,OBJECT_ID('Person.Person'),null,null,'DETAILED')
--����� ��� ���� ����������������� ������

--�������� ��� ���� ������� �� ������� ���������� ���� ���������� ������
select allocated_page_page_id,index_id,* from sys.dm_db_database_page_allocations(7,OBJECT_ID('Person.Person'),null,null,'DETAILED')
where index_id=1


--��� ���� ����  page_level
--0 �������� ����
--max �������� ����
select 
 allocated_page_page_id
,index_id
,page_level
,* from sys.dm_db_database_page_allocations(7,OBJECT_ID('Person.Person'),null,null,'DETAILED')
where index_id=1
order by 3 desc
--����� ��� �������� ���� ���������� �� 903 ��������

--������ ���� ������ �� ������� ���������� ����������������� ������
select 
 allocated_page_file_id
,allocated_page_page_id
,index_id
,page_level
,* from sys.dm_db_database_page_allocations(7,OBJECT_ID('Person.Person'),null,null,'DETAILED')
where index_id=1
order by 4 desc


--������� ���������� ���������� ���� �������� 
--� ������� DBCC PAGE()
--���������� ���������� �������� 
--���������:��,���� �����, ���� ��������, �����(0 ������ HEader,1-�������,2-��������� �� � ���� blob,3 -��������� ������������������) 


DBCC TRACEON(3604)
DBCC PAGE(AdventureWorks2014,1,903,2) --with  TABLERESULTS
--Page Header �������� ���� m_prevPage,m_nextPage = (0:0) ������ �� ����������, ��������� ��������
--����� �������� ��� ����� Data ������� Memory Dump
--��� ���� ������ ������� ������ (������� ������ �������� �� �������) � �������������� �������� ���� ������� ��� ��������
--��� �������� ��� ���������� �� ���� ������, ���� ������. Null ��� ���, ��������� ������ ��� ��� ���. � ������ ��� ����������
--����������� ����� �������� ���  https://www.sql.ru/articles/mssql/2007/011004dbccpagepart1.shtml
--� Offset Table � ������� �������� ���� Offset- ������ ����� ��������  �� ����� Page Header
--���� ������� ��� ������ ������ ������� ����� ������������ �� ���������� ������� ��������  

DBCC PAGE(AdventureWorks2014,1,903,3) --with  TABLERESULTS
--������� ������  �������� �������� BusinessEntityID � ������ �� �������� ��������
--��� �������� �������� 8 �������� �������
--�������� ������ ���, ������ ����� � ������ �� �������� ��������
--������� �������� ������we 919, ��������� �� ������� ����

DBCC PAGE(AdventureWorks2014,1,919,2) 
--� Page Header �������� ��� ���������� �������� 1504, ��������� 915

DBCC PAGE(AdventureWorks2014,1,919,3) 
--������ �������� �������� ��� 501 �������� ������� 
--������� 1441 �������

DBCC PAGE(AdventureWorks2014,1,1441,3) 
--��� ��� �������� ����
--����� ��� ����� �������� ���� ������� �������
--������ �� ���������� �������� 1440, ��������� 1442
--c��������� �������� ����������
--���������� ��� ������ Slots, � ������������� �� ������� Column
--������ �������� �������� 5 ����� (0-4 Slots) � 13 Columns
--� ������ ������ ���� ���� ����� Offset �� ������ �������� ����� Header
--� ������ ������ ���� ���� ����� Length � ������
--� ������ ������ ���� Hash
--� Header ������� ��� ���-�� ���������� ����� m_freeCnt=1184.


--������� ������ ���������� ������� ���������� �� ������ ������
--��������� ������� sys.dm_db_index_physical_stats
--���������: ���� ��, a��� ������� (���� null �� ���), ���� ������� , ������ , �����
select * from sys.dm_db_index_physical_stats(db_id(),	object_id('Person.Person'),NULL,NULL, 'Detailed')
where index_id=1


--���������� ���� ����� ������
select 
 fragment_count
,* 
from sys.dm_db_index_physical_stats(db_id(),	object_id('Person.Person'),NULL,NULL, 'Detailed')
where index_id=1
--����� ��� 1,2,136

--���������� ����� ���������� ������� �� ���� ������� ����� � �������
select 
 fragment_count
,index_level
,page_count
,record_count
,*
from sys.dm_db_index_physical_stats(db_id(),	object_id('Person.Person'),NULL,NULL, 'Detailed')
where index_id=1
-- 8, 3809,19972 �������







--���������� ������� ������� �������� ��� ����
select * from sys.dm_db_database_page_allocations(db_id(),
				NULL, NULL, NULL, 'DETAILED') 
select * from sys.objects
where object_id in (
				SELECT distinct object_id FROM sys.dm_db_database_page_allocations(db_id(),
				NULL, NULL, NULL, 'DETAILED') 
				where index_id=0
				)


--���������� �������  � ������� 3 ���� ������, ���� ����� ���� �������
select * from sys.objects
where object_id in (
				SELECT * FROM sys.dm_db_database_page_allocations(db_id(),
				NULL, NULL, NULL, 'DETAILED') 
 			where  page_level=2
				)

--���� �� ����� ������ Person
select object_id('Person.Person')

--���������� �� �������
select * from sys.indexes where object_id=object_id('Person.Person')




--��������� ����� ��, ������� �� ���� ����� ������������ ��������
SELECT distinct allocated_page_file_id FROM sys.dm_db_database_page_allocations(db_id(),
NULL, NULL, NULL, 'DETAILED')


--��������� ����� �������� ���������� � ���������, ����� �������� ��� ����� ��� ���� � �������������� ������ ������ �����
--��� ��� ���� ������� �������
select * from sys.objects
where object_id in (
				SELECT distinct object_id FROM sys.dm_db_database_page_allocations(db_id(),
				NULL, NULL, NULL, 'DETAILED')
				)

				

--���������� ������� ������� �������� ��� ����
select * from sys.objects
where object_id in (
				SELECT distinct object_id FROM sys.dm_db_database_page_allocations(db_id(),
				NULL, NULL, NULL, 'DETAILED') 
				where index_id=0
				)

--���������� �������  � ������� 3 ���� ������ 
select * from sys.objects
where object_id in (
				SELECT distinct object_id FROM sys.dm_db_database_page_allocations(db_id(),
				NULL, NULL, NULL, 'DETAILED') 
 			where  page_level=2
				)

				select * from Person.Person where BusinessEntityID=80
--����� ���� �� ������, � ��� ���������������� ������� ������ �������� ���� � ��������
select object_id('Person.Person')
select *  FROM sys.dm_db_database_page_allocations(db_id(),
				object_id('Person.Person'), NULL, NULL, 'DETAILED') 
				where page_level=3 and index_id=1


--�������� ���� �������� ������� � ����� 
DBCC PAGE(AdventureWorks2014,1,903,3) --with  TABLERESULTS

DBCC PAGE(AdventureWorks2014,1,903,2)--with  TABLERESULTS
select CONVERT(VarBinary(MAX), '����')
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

	--������ ��� ��������� ������� ������� �������
 DBCC IND(AdventureWorks2014,'Person.Person',-1) 



	DBCC PAGE(AdventureWorks2014,5,16,1) --with  TABLERESULTS






	SELECT * FROM sys.dm_db_database_page_allocations(db_id('AdventureWorks2014'),
NULl, NULL, NULL, 'DETAILED') where page_type=10