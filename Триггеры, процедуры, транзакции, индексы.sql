use bank

--индекс для таблицы RESOURCES на номер счета
CREATE INDEX I1 ON RESOURCES (Number)
--------------------------------------------



--Процедура перевода денег  cчета А на счет B 
CREATE PROCEDURE Perevod 
@A int , @B int , @Value money  -- айди счетов и сумма
AS
BEGIN
 IF @Value<=0  Print('Сумма должна быть больше нуля')
 ELSE
				BEGIN 
 DECLARE @n_value money
	SELECT @n_value=REST from RESOURCES where RESOURCEID=@A;
	IF (@n_value-@Value<0) Print('Отстаток на счете не может быть меньше нуля')
	ELSE
   BEGIN
				BEGIN TRY
      BEGIN TRANSACTION 
								UPDATE RESOURCES 
								SET REST=REST-@Value
	       WHERE RESOURCEID=@A;
	


								UPDATE RESOURCES 
								SET REST=REST+@Value
								WHERE RESOURCEID=@B;
								COMMIT
	    END TRY
BEGIN CATCH
    ROLLBACK TRAN
END CATCH
	   END
				END
END
-------------------------------------------





--Создадим триггер на автоматическое появление сообщения после успешного перевда денег.   


CREATE TRIGGER reminder1  
ON RESOURCES 
AFTER   UPDATE   
AS PRINT ('Вы перевели деньги');  
GO


--проверка
select * from RESOURCES
exec Perevod 2,1, 1000.00
select * from RESOURCES
-------------------------