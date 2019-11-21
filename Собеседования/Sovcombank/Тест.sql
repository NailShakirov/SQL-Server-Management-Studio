CREATE TABLE T (
ID int,
TARIF varchar(10), 
PHONE varchar(10))

drop table T
Alter TABle T
Add con date

CREATE SEQUENCE seq_for_Phone_Tarifs
as int
start with 1
increment by 1


CREATE TRIGGER TriggerName
    ON T
    FOR DELETE, INSERT, UPDATE
    AS
    BEGIN
    SET NOCOUNT ON
    END



drop trigger trig

CREATE TRIGGER trig
on T
instead OF INSERT
as
IF @@rowcount=0
    return
else
BEGIN
insert T
select next VALUE FOR seq_for_Phone_Tarifs,inserted.Tarif,inserted.Phone
from inserted
END


ALTER SEQUENCE seq_for_Phone_Tarifs
RESTART WITH 1

delete from T


insert into T
select 876,'рп','th'
UNION ALL
select '345','0453999'
UNION ALL
select '45','0453999'

select NEXT VALUE FOR seq_for_Phone_Tarifs
select * from T


delete  from T

ALTER TRIGGER trig
on T
instead OF INSERT,UPDATE
as
DECLARE @bit bit
SET @bit= IIF (EXISTS (
								  select PHONE,TARIF from (
												select PHONE,TARIF/*,Date_Tarif*/ from T
												UNION ALL
												select PHONE,TARIF/*,Date_Tarif*/ from inserted
												)as temp
												group by PHONE,TARIF/*,Date_Tarif*/
												having count(PHONE)>1
							 ),1,0)
IF EXISTS (select * from deleted)
				BEGIN 
								IF @bit =1 
												PRINT('Записи дублируются!!!Апдейт отменен')
								ELSE 
												update T
												SET T.PHONE=inserted.Phone,
																T.TARIF=inserted.TARIF
																/*,T.Date_Tarif*=inserted.Date_Tarif*/
            from T join inserted
																on T.ID=inserted.ID
				END
ELSE 
				BEGIN 
								IF @bit =1 
												PRINT('Записи дублируются!!!Вставка отменена')
								ELSE 
												insert T
												select next VALUE FOR seq_for_Phone_Tarifs,inserted.Tarif,inserted.Phone
												from inserted
				END






IF EXISTS (select * from inserted)
				BEGIN
				IF EXISTS (
								select PHONE,TARIF from (
												select PHONE,TARIF/*,Date_Tarif*/ from T
												UNION ALL
												select PHONE,TARIF/*,Date_Tarif*/ from inserted
												)as temp
												group by PHONE,TARIF/*,Date_Tarif*/
												having count(PHONE)>1
							 )
								BEGIN 
												PRINT('Записи дублируются!!!Вставка отменена')
												RETURN
								END 
				ELSE
								BEGIN
												insert T
												select next VALUE FOR seq_for_Phone_Tarifs,inserted.Tarif,inserted.Phone
												from inserted
												RETURN
								END
				END
IF EXISTS (select * from deleted)
				BEGIN
				IF EXISTS (
								select PHONE,TARIF from (
												select PHONE,TARIF/*,Date_Tarif*/ from T
								 			UNION ALL
												select PHONE,TARIF/*,Date_Tarif*/ from deleted
												)as temp
												group by PHONE,TARIF/*,Date_Tarif*/
												having count(PHONE)>1
							 )
								BEGIN 
												PRINT('Записи дублируются!!!Апдейт отменен')
												RETURN
								END 
				END
		
			




INSERT T
SELECT 345,'r','h'


UPDATE T
set PHONE='j' where Tarif='r'

DELETE from T
select * from T
	
	
	
	
	
	
	select T.PHONE,T.TARIF 
			from T 
		
			group by T.PHONE,T.TARIF--,T.Date_Tarif
			having count(T.PHONE)>1
	
	
	
	
	
			  

BEGIN 
select 1
begin
select 2
return
end
select 3
end