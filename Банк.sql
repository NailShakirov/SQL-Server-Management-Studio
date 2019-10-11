CREATE DATABASE BANK
GO
USE BANK
GO

------------------------------------------------------------------
CREATE TABLE Clients (--таблица клиентов банка
 ClientID			INT IDENTITY(1,1)  PRIMARY KEY    --айди коиента
,Name							NVARCHAR(100)  Not Null															--Имя           
,SurName				NVARCHAR(100) Not Null													--Фамилия
,Sex								TINYINT 																															--Пол (1-муж,0-жен)
,BirthDay			DATE    																										--Дата рождения
,Country				NVARCHAR(100) 																					--Страна, где родился клиент
,Region					NVARCHAR(200)																							--Регион (ресублика,область, штат), где родился клиент
,City							NVARCHAR(200) 																								--Населенный пункт (город, село и пр), где родился клиент
,[Type]     NVARCHAR(3)                           --ТИП (физ лицо или юр лицо)
)
GO
------------------------------------------------------------------


--заполним таблицу Clients-------------------------------------------
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
SELECT 'Иванов','Иван',1,'1970-01-01','Россия','Республика Татарстан','Казань','Физ'
UNION ALL
SELECT 'Александров','Александр',1,'1989-05-01','Россия','Республика Башкортостан','Уфа','Физ'
UNION ALL
SELECT 'Исмагилова','Эльмира',0,'1999-11-21','Россия','Московская область','Москва','Физ'
UNION ALL
SELECT 'Петров','Николай',1,'2011-01-01','Россия','Кировская область','Киров','Физ'
UNION ALL
SELECT 'Нестеренко','Дмитрий',1,'1960-04-13','Украина','Днепропетровская область','Днепропетровск','Физ'
UNION ALL
SELECT 'Федорова','Ксения',0,'1990-12-31','Россия','Республика Татарстан','Чистополь','Юр'
UNION ALL
SELECT 'Соболев','Даниил',1,'1955-01-01','Россия','Республика Удмуртия','Ижевск','Физ'
GO
--SELECT  * FROM Clients
--------------------------------------------------------------------------------



---------- таблица телефонов клиентов-------------------------------------------
CREATE TABLE PhoneNumbers  (
 PhoneID INT IDENTITY(1,1) Primary KEy                    --айди номера
,СlientID INT FOREIGN KEY REFERENCES  Clients  ON DELETE CASCADE --ссылка на клиента, каскадное удаление
,Number  NVARCHAR(11)  Not Null                            --Сам номер
,[Type]  NVARCHAR(20)                                     --тип номера телефона (домашний, рабочий, cотовый и пр)
)
GO
--------------------------------------------------------------------------------



---заполним таблицу PhoneNumbers---
INSERT INTO PhoneNumbers 
( СlientID
	,Number  
	,[Type]  )
SELECT 1,'89173223232','сотовый'
UNION ALL
SELECT 2,'89632423232','сотовый'
UNION ALL
SELECT 2,'88433223772','рабочий'
UNION ALL
SELECT 2,'88435599664','домашний'
UNION ALL
SELECT 3,'89178627074','сотовый'
UNION ALL
SELECT 4,'88553328802','домашний'
UNION ALL
SELECT 5,'89173223232','сотовый'
UNION ALL
SELECT 5,'89953245232','сотовый'
UNION ALL
SELECT 7,'89872627956','сотовый'
UNION ALL
SELECT 7,'89431111434','рабочий'
GO

--select * from PhoneNumbers
--------------------------------------




---------таблица счетов у клиентов---------------------------------------
CREATE TABLE RESOURCES (
 RESOURCEID INT IDENTITY(1,1) Primary KEy        --айди СЧЕТА
,СlientID  INT FOREIGN KEY REFERENCES  Clients  ON DELETE CASCADE --ссылка на клиента, каскадное удаление
,Number    NVARCHAR(20) Not NUll                    --счет
,[Type]    NVARCHAR(40) Not NUll                    --тип  (кредитный,ресчетный, депозитный)
,Rest      MONEY   CHECK (REST>=0)                  --Остаток на счете,ограничение на неотрицательность
)
-------------------------------------------------------------------------


---заполним таблицу RESOURCES---
INSERT INTO RESOURCES 
(  СlientID
		,Number  
		,[Type]  
		,Rest   )
SELECT 1,'40843434656565835712','расчетный',2000.34
UNION ALL
SELECT 2,'40843456556989583567','расчетный',15666.76
UNION ALL
SELECT 2,'47443434787565835712','кредитный',160654.84
UNION ALL
SELECT 2,'42343476764544568644','депозитный',6600.12
UNION ALL
SELECT 3,'40823424353453535334','расчетный',3000.84
UNION ALL
SELECT 3,'41743434656565835712','расчетный',88000.34
UNION ALL
SELECT 5,'40843453535353535351','расчетный',14000.98
UNION ALL
SELECT 5,'42386832878607925454','депозитный',4335.34
UNION ALL
SELECT 6,'40834535375677446456','расчетный',4653.77
UNION ALL
SELECT 7,'40887874543327678775','расчетный',1324.44
UNION ALL
SELECT 7,'47435465587565833535','кредитный',7654.43
GO

--select * from Clients
--drop table RESOURCES
--drop table PhoneNumbers
--drop table Clients

--------------------------------------