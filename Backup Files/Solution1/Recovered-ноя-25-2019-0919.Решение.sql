CREATE DATABASE My_BASE
USE My_BASE
--drop database My_BASE
--use master
----City----
CREATE SEQUENCE [dbo].[seq_for_city]
as int
start with 1
increment by 1

CREATE TABLE [dbo].[City](
  [ID]   int 
	,[Name] nvarchar(60)
)
INSERT [dbo].[City]
select next value for [dbo].[seq_for_city],'UNKNOWN'
------------


----Company----
CREATE SEQUENCE [dbo].[seq_for_company]
as int
start with 1
increment by 1


CREATE TABLE [dbo].[Company](
  [ID]   int
	,[Name] nvarchar(60)
)
INSERT [dbo].[Company]
select next value for [dbo].[seq_for_company],'UNKNOWN'
-----------










drop proc Input_Developer

CREATE PROC Input_Developer
				@Name nvarchar(60) ,
				@Level int,
				@ExperienceInYears int,
				@CityName nvarchar(60) ='UNKNOWN',
				@CompanyName nvarchar(60) ='UNKNOWN'
AS
				SET NOCOUNT OFF

Declare @City_id int
SELECT @City_id=ID from [dbo].[City] where Name=@CityName

Declare @Company_id int
Select @Company_id=ID from [dbo].[Company] where Name=@CompanyName
IF @City_id is null
				BEGIN 
								SET @City_id = next value for [dbo].[seq_for_city] 
								INSERT [dbo].[City]
								SELECT @City_id,@CityName
				END

IF @Company_id is null
				BEGIN 
								SET @Company_id = next value for [dbo].[seq_for_company] 
								INSERT [dbo].[Company]
								SELECT @Company_id,@CompanyName
				END


INSERT  [dbo].[Developer]
SELECT @Name,@Company_id,@City_id,@Level,@ExperienceInYears

INSERT  [dbo].[Developer]
SELECT 'Ильнур',2,1,1,1

exec Input_Developer 'Ильнур',1,1,'Maxima','Казань'


delete from [dbo].[Developer]

select * from Developer
select * from City
 drop table [dbo].[Developer]
CREATE TABLE [dbo].[Developer] (
 [ID]   int IDENTITY(1,1)
,[Name] nvarchar(60)
,[Company] int
,[ActualCity] int 
,[Level] int 
,[ExperienceInYears] int
)








insert into [dbo].[Developer]
select 'Иван',10,1,1,3
UNION ALL 
select 'Михаил',2,3,2,2
UNION ALL 
select 'Ильнур',1,4,1,1
--select * from [dbo].[Developer]

CREATE TABLE [dbo].[DeveloperLanguage] (
,[Id]    int
,[Language] nvarchar (30) 
,[Developer] int
) 

insert [dbo].[DeveloperLanguage]
select 'T-SQL',1
UNION ALL 
select 'Java', 1
UNION ALL 
select 'MySQL', 1
UNION ALL 
select 'NoSQL', 2
UNION ALL 
select 'C#', 2
UNION ALL 
select 'C++', 2
UNION ALL 
select 'Python', 3
UNION ALL 
select 'PHP', 3
UNION ALL 
select 'T-SQL', 3
UNION ALL 
select 'My-SQL', 3

CREATE TABLE [dbo].[Company](
  [ID]   int
	,[Name] nvarchar(60)
)
INSERT [dbo].[Company]
select 1,'Maxima' 
UNION ALL 
select 2,'Sovcombank'
UNION ALL 
select 3,'Sberbank'
UNION ALL 
select 4,'Gazprom'
UNION ALL 
select 5,'Tatneft'
UNION ALL 
select 6,'Yandex'
UNION ALL 
select 7,'Mail.group'
UNION ALL 
select 8,'SkyEng'
UNION ALL 
select 9,'Bars.group'
--select * from [dbo].[Company]



CREATE TABLE [dbo].[City](
  [ID]   int
	,[Name] nvarchar(60)
)

INSERT [dbo].[City]
select 1,'Казань'
UNION ALL 
select 2,'Москва'
UNION ALL 
select 3,'Екатеринбург'
UNION ALL 
select 4,'Нижний Новгород'
UNION ALL 
select 5,'Хабаровск'
UNION ALL 
select 6,'Набережные Челны'
UNION ALL 
select 7,'Новосибирск'
UNION ALL 
select 8,'Иркутск'
UNION ALL 
select 9,'Пермь'
--select * from [dbo].[City]




CREATE TABLE [dbo].[DeveloperDBMS](
  [ID]   int   identity(1,1)
 ,[Developer]   int
	,[Version]    nvarchar(15)
	,[DBMS] int

)
INSERT dbo.DeveloperDBMS
select 1,'2008',1
UNION ALL
select 1,'2005',1
UNION ALL
select 1,'2002',1
UNION ALL
select 1,'2012',1
UNION ALL
select 1,'2014',1
UNION ALL
select 1,'2016',1
UNION ALL
select 1,'4.0',2
UNION ALL
select 1,'6.0',2
UNION ALL
select 1,'5.7',2
UNION ALL
select 1,'8.0',2
UNION ALL
select 1,'2005',1



CREATE PROCEDURE dbo.input_candidate   

AS
SET NOCOUNT ON
 






CREATE TABLE [dbo].[DBMS](
  [ID]   int
 ,[Name] nvarchar(60)
)
INSERT [dbo].[DBMS]
SELECT 1, 'MS SQL SERVER'
UNION ALL
SELECT 2, 'My_SQL'
UNION ALL
SELECT 3, 'PostgreSQL'
UNION ALL
SELECT 4, 'Oracle Database'
UNION ALL
SELECT 5, 'DB2'
--select * from [dbo].[DBMS]

CREATE TABLE [dbo].[DeveloperDBMSTag](
 [ID]   int
	,[DeveloperDBMS] int
	,[Tag]  nvarchar(20)

)

CREATE TABLE [dbo].[DeveloperLanguageTag](
  DeveloperLanguage   int
	,[IsWriter] int
	,[Tag]  nvarchar(20)
)




 





CREATE TABLE fyf.D (
Name nvarchar(60)


)

sp_help '[dbo].[Developer]'
Insert dbo.