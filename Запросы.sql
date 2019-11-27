Use BANK

--Подзапрос

--№1-- Найти Клиента,у которого остаток на счете максимальный
SELECT Name, SurName from Clients where ClientID = (SElECT TOP(1) 
СlientID from RESOURCES order by Rest desc)


--#2 -- Найти все номера телефонов людей,кто проживает в Казани
SELECT Number,Type  from PhoneNumbers where СlientID = (Select ClientID from Clients where City='Казань')




--Union 
--Выбреать физ клиентов и юр  клиентов

Select * from Clients where Type='Физ'
Union ALL
Select * from Clients where Type='Юр'
Go


--Join 
--Вывести все счета людей проживаюих в России

Select a.* 
from RESOURCES  a 
JOIN  Clients b
ON a.СlientID=b.ClientID
AND b.Country='Россия'
GO

--запросы с примененимем коллации





SELECT Name, SurName from Clients  
ORDER BY SurName  
COLLATE Tatar_90_CS_AS_KS_WS_SC ASC;  
GO 
 

SELECT Name, SurName from Clients  
ORDER BY SurName  
COLLATE Albanian_100_CS_AS_KS_WS_SC ASC; 





--Вьюха показывающая все уникальные метсо прживания клиентов

CREATE VIEW PLaces as
SELECT DIStinct  Country, City from Clients 
--select * from PLaces