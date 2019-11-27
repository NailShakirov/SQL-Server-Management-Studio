DECLARE @jsonInfo NVARCHAR(MAX)

SET @jsonInfo=N'{  
     "Name":"Иван",
					"Level":1,
					"ExperienceInYears":2,
					"City":"Казань",
					"Company":"Maxima",
					"DeveloperLanguage":[
				 			{"Language":"C#",
								"DeveloperLanguageTag":[".Net","ASP.Net"]
												},
								{"Language":"Python",
								 "DeveloperLanguageTag":["NumPy,"Pandas"]
												}
						],
					"DeveloperDBMS":[
								{
								 "DBMS":"MS SQL",
								 "Versions":["2005,"2012","2016"],
									"DeveloperDBMSTag":["admin","OLTP"]
									},
								{
								 "DBMS":"My_SQL",
								 "Versions":["5.0,"4.4","6.0"],
									"DeveloperDBMSTag":["admin"]
									}
				]							  
 }' 
	
	Print ISJSON(@jsonInfo)

	select is
	
	DECLARE @jsonInfo NVARCHAR(MAX)

SET @jsonInfo=N'{  
     "info":{    
       "type":1,  
       "address":{    
         "town":"Bristol",  
         "county":"Avon",  
         "country":"England"  
       },  
       "tags":["Sport", "Water polo"]  
    },  
    "type":"Basic"  
 }'   

	use My_BASE
	select * from Developer


	BEGIN TRY
			

		--INSERT Developer
		select 66/0
	END TRY

	BEGIN CATCH
	select 6
	-- THROW
					
END CATCH



select * from sys.messages where language_id=1049 and message_id=213
