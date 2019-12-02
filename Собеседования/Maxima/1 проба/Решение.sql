CREATE DATABASE My_BASE
GO
USE My_BASE



Create SEQUENCE [dbo].[seq_for_city]
as int
	start with 1
	Increment by 1

Create SEQUENCE [dbo].[seq_for_developer]
as int
	start with 1
	Increment by 1

Create SEQUENCE [dbo].[seq_for_company]
as int
	start with 1
	Increment by 1



CREATE TABLE [dbo].[City](
     [ID]   int
	,[Name] nvarchar(60)
)

CREATE TABLE [dbo].[Company](
     [ID]   int
	,[Name] nvarchar(60)
)

CREATE TABLE [dbo].[Developer] (
 [ID]   int 
,[Name] nvarchar(60)
,[Level] int 
,[ExperienceInYears] int
,[Company] int
,[ActualCity] int 
)

CREATE TABLE [dbo].[DeveloperLanguage] (
 [ID]  int IDENTITY(1,1)
,[Language] nvarchar (30) 
,[Developer] int
) 

CREATE TABLE [dbo].[DeveloperLanguageTag](
     [ID]   int IDENTITY(1,1)
	,[DeveloperLanguage] int
	,[IsWriter] int
	,[Tag]  nvarchar(20)
)

CREATE TABLE [dbo].[DBMS](
	[ID] int IDENTITY(1,1) ,
	[Name] nvarchar(50) 
) 

CREATE TABLE [dbo].[DeveloperDBMS](
     [ID]   int Identity(1,1) 
    ,[Developer]   int
	,[Version]    nvarchar(15)
	,[DBMS] int

)

CREATE TABLE [dbo].[DeveloperDBMSTag](
     [ID]   int  Identity(1,1) 
	,[DeveloperDBMS] int
	,[Tag]  nvarchar(20)

)












--drop PROC [dbo].[input_developer]

CREATE PROC [dbo].[input_developer]
	@DATA NVARCHAR(max)
as
 
declare @Name nvarchar(50) = JSON_VALUE(@DATA,'$.Name')
declare @Level int = JSON_VALUE(@DATA,'$.Level')
declare @ExperienceInYears int = JSON_VALUE(@DATA,'$.ExperienceInYears')
declare @City nvarchar(50) = JSON_VALUE(@DATA,'$.City')
declare @Company nvarchar(100) = JSON_VALUE(@DATA,'$.Company')



DECLARE @Developer_ID int = next value for [dbo].[seq_for_developer]

declare @City_id int
select @City_id=ID from [dbo].[City] where Name = @City

declare @Company_id int
select @Company_id=ID from [dbo].[Company] where Name = @Company

Begin TRY
SET NOCOUNT ON

	BEGIN TRAN

if @City_id is null
	begin 
	    SEt @City_id =  next value for [dbo].[seq_for_city]
		insert [dbo].[City]
		select @City_id, @City
	end

if @Company_id is null
	begin 
	    SEt @Company_id =  next value for [dbo].[seq_for_Company]
		insert [dbo].[Company]
		select @Company_id, @Company
	end

INSERT [dbo].[Developer]
select @Developer_ID,@Name,@Level,@ExperienceInYears,@Company_id,@City_id

DECLARE @temp_language_tag TABLE ([Language]  NVARCHAR(50), [ISWriter] int, [DeveloperLanguageTag] NVARCHAR(50))
INSERT @temp_language_tag 
select  json_value(T.value,'$.Language') as Language,
        json_value(T.value,'$.IsWriter') as ISWriter,
        B.value as DeveloperLanguageTag 
from OPENJSON(JSON_QUERY(@DATA,'$.DeveloperLanguage')) as T
cross apply OPENJSON(JSON_QUERY(@DATA,'$.DeveloperLanguage['+CAST(T.[key] as nvarchar(2))+'].DeveloperLanguageTag')) as B


INSERT [dbo].[DeveloperLanguage]
SELECT distinct(Language),@Developer_ID from @temp_language_tag

INSERT [dbo].[DeveloperLanguageTag]
select a.ID, b.ISWriter,b.DeveloperLanguageTag
from [DeveloperLanguage] as a
join @temp_language_tag  as b
on a.Developer =@Developer_ID and a.Language=b.Language


DECLARE @temp_DBMS_tag TABLE ([DBMS] NVARCHAR(50), Versions NVARCHAR(50),[Tag] NVARCHAR(50))
INSERT @temp_DBMS_tag 
select  json_value(T.value,'$.DMBS') as DBMS,
        B.value as Versions,
        C.value as Tag
from OPENJSON(JSON_QUERY(@DATA,'$.DeveloperDBMS')) as T
cross apply OPENJSON(JSON_QUERY(@DATA,'$.DeveloperDBMS['+CAST(T.[key] as nvarchar(2))+'].Versions')) as B
cross apply OPENJSON(JSON_QUERY(@DATA,'$.DeveloperDBMS['+CAST(T.[key] as nvarchar(2))+'].DevepolerDBMSTag')) as C


INSERT [dbo].[DBMS]
SELECT distinct(DBMS) from @temp_DBMS_tag 
where [DBMS] not in  (select [Name] from [dbo].[DBMS])

INSERT [dbo].[DeveloperDBMS]
select @Developer_ID,A.Versions,B.ID
from @temp_DBMS_tag as A
join [dbo].[DBMS]  as B
on B.[Name]=A.DBMS



INSERT [dbo].[DeveloperDBMSTag]
select A.ID,B.Tag
from [DeveloperDBMS] as A
join [dbo].[DBMS] as C
on   A.DBMS=C.ID
join @temp_DBMS_tag as B
on  A.Version=B.Versions
where A.Developer=@Developer_ID
Commit
Set NOCOUNT OFF;

END TRY
BEGIN CATCH
		Rollback TRANSACTION;

	Set NOCOUNT OFF;
	THROW;

END CATCH
 

DECLARE @Person_1 NVARCHAR(4000)=
N'{
                    "Name":"Ìèøà",
					"Level":1,
					"ExperienceInYears":2,
					"City":"Êàçàíü",
					"Company":"Maxima",
					"DeveloperLanguage":[
				 			    {"Language":"C#",
								 "IsWriter":1,
								 "DeveloperLanguageTag":[".Net","ASP.Net"]
												},
								{"Language":"Python",
								 "IsWriter":1,
								 "DeveloperLanguageTag":["Numpy","Pandas"]
												},
								{"Language":"T-SQL",
								 "IsWriter":1,
								 "DeveloperLanguageTag":["index","lock"]
												}
						],
					"DeveloperDBMS":[
								{
								 "DMBS":"MS_SQL",
								 "Versions":["2005","2008","2016"],
								 "DevepolerDBMSTag":["admin","OLTP"]
									},
								{
								 "DMBS":"My SQL",
								 "Versions":["5.0","6.0"],
								 "DevepolerDBMSTag":["admin"]
									}
				]							  
 }' 


DECLARE @Person_2 NVARCHAR(4000)=
N'{
                    "Name":"Èëüíóð",
					"Level":2,
					"ExperienceInYears":2,
					"City":"Ìîñêâà",
					"Company":"Yandex",
					"DeveloperLanguage":[
				 			    {"Language":"C++",
								 "IsWriter":1,
								 "DeveloperLanguageTag":[".Net","ASP.Net"]
												},
								{"Language":"JavaScript",
								 "IsWriter":1,
								 "DeveloperLanguageTag":["NOde.js","Angular"]
												},
								{"Language":"T-SQL",
								 "IsWriter":1,
								 "DeveloperLanguageTag":["index","lock","view","procedure"]
												}
						],
					"DeveloperDBMS":[
								{
								 "DMBS":"MS_SQL",
								 "Versions":["2005","2008","2016"],
								 "DevepolerDBMSTag":["optimization","OLTP"]
									},
								{
								 "DMBS":"My SQL",
								 "Versions":["5.0","5.5"],
								 "DevepolerDBMSTag":["admin","optimization"]
									},
								{
								 "DMBS":"PostgreSQL",
								 "Versions":["All"],
								 "DevepolerDBMSTag":["admin","optimization"]
									}
				]							  
 }' 


 DECLARE @Person_3 NVARCHAR(4000)=
N'{
                    "Name":"Ìàêñèì",
					"Level":3,
					"ExperienceInYears":4,
					"City":"Íîâîñèáèðñê",
					"Company":"Sovcombank",
					"DeveloperLanguage":[
				 			    {"Language":"C#",
								 "IsWriter":1,
								 "DeveloperLanguageTag":[".Net","ASP.Net"]
												},
								{"Language":"JavaScript",
								 "IsWriter":1,
								 "DeveloperLanguageTag":["NOde.js","Angular"]
												},
								{"Language":"T-SQL",
								 "IsWriter":1,
								 "DeveloperLanguageTag":["index","lock","view","procedure","function","triggers"]
												}
						],
					"DeveloperDBMS":[
								{
								 "DMBS":"MS_SQL",
								 "Versions":["2005","2008","2016","2017","2019"],
								 "DevepolerDBMSTag":["optimization","OLTP"]
									},
								{
								 "DMBS":"DB2",
								 "Versions":["3.0","4.0"],
								 "DevepolerDBMSTag":["admin","optimization"]
									},
								{
								 "DMBS":"PostgreSQL",
								 "Versions":["All"],
								 "DevepolerDBMSTag":["admin","optimization"]
									},
								{
								 "DMBS":"Oracle Database",
								 "Versions":["All"],
								 "DevepolerDBMSTag":["admin","optimization"]
									}
				]							  
 }' 

 DECLARE @Person_4 NVARCHAR(4000)=
N'{
                    "Name":"Íàèëü",
					"Level":4,
					"ExperienceInYears":3,
					"City":"Êàçàíü",
					"Company":"SkyEng",
					"DeveloperLanguage":[
				 			    {"Language":"Python",
								 "IsWriter":1,
								 "DeveloperLanguageTag":["NumPy","Pandas"]
												},
								{"Language":"JavaScript",
								 "IsWriter":1,
								 "DeveloperLanguageTag":["GoogleJS","Node.js"]
												},
								{"Language":"T-SQL",
								 "IsWriter":1,
								 "DeveloperLanguageTag":["index","lock","view","procedure","trigger","fucntion","sequnce"]
												}
						],
					"DeveloperDBMS":[
								{
								 "DMBS":"MS_SQL",
								 "Versions":["2005","2008","2012","2014","2016"],
								 "DevepolerDBMSTag":["optimization","OLTP","admin","lock"]
									},
								{
								 "DMBS":"My SQL",
								 "Versions":["5.0","5.5"],
								 "DevepolerDBMSTag":["admin","optimization"]
									},
								{
								 "DMBS":"PostgreSQL",
								 "Versions":["All"],
								 "DevepolerDBMSTag":["admin","optimization"]
									}
				]							  
 }' 


 


 --exec input_developer @Person_1
 --exec input_developer @Person_2
 --exec input_developer @Person_3
 --exec input_developer @Person_4

/*

 select * from City
 select * from Company
 select * from DeveloperLanguage
 select * from DeveloperLanguageTag
 select * from Developer
 select * from DBMS
 select * from DeveloperDBMS
 select * from DeveloperDBMSTag
 */



 with Candidate as (
    select d.Name as DeveloperName, d.[Level],
            (
                case 
                    when exists (select * from dbo.DeveloperLanguage as dl where dl.[Language] in ('C#', 'Java', 'Delphi')) then 1 
                    else 0 
                end +
                iif(ddbt.Id is null, 0, 1) +
                iif(dlt.Id is null, 0, 1)
            ) as Advantage
		--,ROW_NUMBER() over (partition by d.Name order by [Level] + Advantage desc) as position
        from dbo.Developer as d
        inner join dbo.Company as c on c.Id = d.Company
        inner join dbo.City as ct on ct.Id = d.ActualCity
        inner join dbo.DeveloperDBMS as ddb on ddb.Developer = d.Id
        inner join dbo.DeveloperLanguage as dl on dl.Developer = d.Id and dl.[Language] = 'T-SQL'
        inner join dbo.DBMS as db on db.Id = ddb.DBMS
        left join dbo.DeveloperDBMSTag as ddbt on ddbt.DeveloperDBMS = ddb.Id and ddbt.Tag = 'AlwaysOn'
        left join dbo.DeveloperLanguageTag as dlt on dlt.DeveloperLanguage = dl.Id and dlt.IsWriter = 1 and dlt.Tag = 'MOT'
        where 
            ct.Name = 'Êàçàíü' and c.Name != 'Maxima' and 
            db.Name = 'MS_SQL' and ddb.[Version] in ('2008', '2012', '2014', '2016') and
            (select count(*) from dbo.DeveloperDBMSTag as ddbt where ddbt.DeveloperDBMS = ddb.Id and ddbt.Tag in ('OLTP', 'lock', 'transaction', 'optimization', 'admin')) >= 4 and
            (
                select count(*)
                    from dbo.DeveloperLanguageTag as dlt
                    where dlt.DeveloperLanguage = dl.Id and dlt.IsWriter = 1 and dlt.Tag in ('index', 'procedure', 'function', 'trigger', 'view')
            ) > 3 and
            d.ExperienceInYears >= 2
),

candidate_with_position as  (
select *
 ,ROW_NUMBER() over (partition by DeveloperName order by [Level] + Advantage desc) as position
 from Candidate
)

select DeveloperName from candidate_with_position where position=1















