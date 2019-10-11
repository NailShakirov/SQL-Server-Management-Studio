use bank

--������ ��� ������� RESOURCES �� ����� �����
CREATE INDEX I1 ON RESOURCES (Number)
--------------------------------------------



--��������� �������� �����  c���� � �� ���� B 
CREATE PROCEDURE Perevod 
@A int , @B int , @Value money  -- ���� ������ � �����
AS
BEGIN
 IF @Value<=0  Print('����� ������ ���� ������ ����')
 ELSE
				BEGIN 
 DECLARE @n_value money
	SELECT @n_value=REST from RESOURCES where RESOURCEID=@A;
	IF (@n_value-@Value<0) Print('�������� �� ����� �� ����� ���� ������ ����')
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





--�������� ������� �� �������������� ��������� ��������� ����� ��������� ������� �����.   


CREATE TRIGGER reminder1  
ON RESOURCES 
AFTER   UPDATE   
AS PRINT ('�� �������� ������');  
GO


--��������
select * from RESOURCES
exec Perevod 2,1, 1000.00
select * from RESOURCES
-------------------------