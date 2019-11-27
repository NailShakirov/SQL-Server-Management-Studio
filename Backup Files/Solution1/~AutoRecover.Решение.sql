CREATE DATABASE My_BASE
USE My_BASE



CREATE TABLE [dbo].[Developer] (
 [ID]   int IDENTITY(1,1)
,[Name] nvarchar(60)
,[Level] int 
,[Company] int
,[ActualCity] int 
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
  ID  int
 [Language] nvarchar (30) 
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
  [ID]   int
 ,[Developer]   int
	,[Version]    nvarchar(15)
	,[DBMS] int

)


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
 [ID]   int
	,[IsWriter] int
	,[Tag]  nvarchar(20)
	,[DeveloperLanguage] int
)








CREATE TABLE fyf.D (
Name nvarchar(60)


)

sp_help '[dbo].[Developer]'
Insert dbo.