Use BANK

--���������

--�1-- ����� �������,� �������� ������� �� ����� ������������
SELECT Name, SurName from Clients where ClientID = (SElECT TOP(1) 
�lientID from RESOURCES order by Rest desc)


--#2 -- ����� ��� ������ ��������� �����,��� ��������� � ������
SELECT Number,Type  from PhoneNumbers where �lientID = (Select ClientID from Clients where City='������')




--Union 
--�������� ��� �������� � ��  ��������

Select * from Clients where Type='���'
Union ALL
Select * from Clients where Type='��'
Go


--Join 
--������� ��� ����� ����� ���������� � ������

Select a.* 
from RESOURCES  a 
JOIN  Clients b
ON a.�lientID=b.ClientID
AND b.Country='������'
GO

--������� � ������������ ��������





SELECT Name, SurName from Clients  
ORDER BY SurName  
COLLATE Tatar_90_CS_AS_KS_WS_SC ASC;  
GO 
 

SELECT Name, SurName from Clients  
ORDER BY SurName  
COLLATE Albanian_100_CS_AS_KS_WS_SC ASC; 





--����� ������������ ��� ���������� ����� ��������� ��������

CREATE VIEW PLaces as
SELECT DIStinct  Country, City from Clients 
--select * from PLaces