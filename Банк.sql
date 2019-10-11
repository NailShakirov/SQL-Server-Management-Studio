CREATE DATABASE BANK
GO
USE BANK
GO

------------------------------------------------------------------
CREATE TABLE Clients (--������� �������� �����
 ClientID			INT IDENTITY(1,1)  PRIMARY KEY    --���� �������
,Name							NVARCHAR(100)  Not Null															--���           
,SurName				NVARCHAR(100) Not Null													--�������
,Sex								TINYINT 																															--��� (1-���,0-���)
,BirthDay			DATE    																										--���� ��������
,Country				NVARCHAR(100) 																					--������, ��� ������� ������
,Region					NVARCHAR(200)																							--������ (���������,�������, ����), ��� ������� ������
,City							NVARCHAR(200) 																								--���������� ����� (�����, ���� � ��), ��� ������� ������
,[Type]     NVARCHAR(3)                           --��� (��� ���� ��� �� ����)
)
GO
------------------------------------------------------------------


--�������� ������� Clients-------------------------------------------
INSERT INTO Clients 
(
 Name					
,SurName		
,Sex						
,BirthDay	
,Country		
,Region			
,City
,[Type]	)				
SELECT '������','����',1,'1970-01-01','������','���������� ���������','������','���'
UNION ALL
SELECT '�����������','���������',1,'1989-05-01','������','���������� ������������','���','���'
UNION ALL
SELECT '����������','�������',0,'1999-11-21','������','���������� �������','������','���'
UNION ALL
SELECT '������','�������',1,'2011-01-01','������','��������� �������','�����','���'
UNION ALL
SELECT '����������','�������',1,'1960-04-13','�������','���������������� �������','��������������','���'
UNION ALL
SELECT '��������','������',0,'1990-12-31','������','���������� ���������','���������','��'
UNION ALL
SELECT '�������','������',1,'1955-01-01','������','���������� ��������','������','���'
GO
--SELECT  * FROM Clients
--------------------------------------------------------------------------------



---------- ������� ��������� ��������-------------------------------------------
CREATE TABLE PhoneNumbers  (
 PhoneID INT IDENTITY(1,1) Primary KEy                    --���� ������
,�lientID INT FOREIGN KEY REFERENCES  Clients  ON DELETE CASCADE --������ �� �������, ��������� ��������
,Number  NVARCHAR(11)  Not Null                            --��� �����
,[Type]  NVARCHAR(20)                                     --��� ������ �������� (��������, �������, c������ � ��)
)
GO
--------------------------------------------------------------------------------



---�������� ������� PhoneNumbers---
INSERT INTO PhoneNumbers 
( �lientID
	,Number  
	,[Type]  )
SELECT 1,'89173223232','�������'
UNION ALL
SELECT 2,'89632423232','�������'
UNION ALL
SELECT 2,'88433223772','�������'
UNION ALL
SELECT 2,'88435599664','��������'
UNION ALL
SELECT 3,'89178627074','�������'
UNION ALL
SELECT 4,'88553328802','��������'
UNION ALL
SELECT 5,'89173223232','�������'
UNION ALL
SELECT 5,'89953245232','�������'
UNION ALL
SELECT 7,'89872627956','�������'
UNION ALL
SELECT 7,'89431111434','�������'
GO

--select * from PhoneNumbers
--------------------------------------




---------������� ������ � ��������---------------------------------------
CREATE TABLE RESOURCES (
 RESOURCEID INT IDENTITY(1,1) Primary KEy        --���� �����
,�lientID  INT FOREIGN KEY REFERENCES  Clients  ON DELETE CASCADE --������ �� �������, ��������� ��������
,Number    NVARCHAR(20) Not NUll                    --����
,[Type]    NVARCHAR(40) Not NUll                    --���  (���������,���������, ����������)
,Rest      MONEY   CHECK (REST>=0)                  --������� �� �����,����������� �� �����������������
)
-------------------------------------------------------------------------


---�������� ������� RESOURCES---
INSERT INTO RESOURCES 
(  �lientID
		,Number  
		,[Type]  
		,Rest   )
SELECT 1,'40843434656565835712','���������',2000.34
UNION ALL
SELECT 2,'40843456556989583567','���������',15666.76
UNION ALL
SELECT 2,'47443434787565835712','���������',160654.84
UNION ALL
SELECT 2,'42343476764544568644','����������',6600.12
UNION ALL
SELECT 3,'40823424353453535334','���������',3000.84
UNION ALL
SELECT 3,'41743434656565835712','���������',88000.34
UNION ALL
SELECT 5,'40843453535353535351','���������',14000.98
UNION ALL
SELECT 5,'42386832878607925454','����������',4335.34
UNION ALL
SELECT 6,'40834535375677446456','���������',4653.77
UNION ALL
SELECT 7,'40887874543327678775','���������',1324.44
UNION ALL
SELECT 7,'47435465587565833535','���������',7654.43
GO

--select * from Clients
--drop table RESOURCES
--drop table PhoneNumbers
--drop table Clients

--------------------------------------