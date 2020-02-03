---------запускаем на одной базе


select  a.name as [user] ,b.name as [login] 
--into ##tmp2
from sys.database_principals a
join  sys.server_principals b
on a.sid=b.sid
where a.principal_id>1
--select * from ##tmp2

select a.*,USER_NAME(b.role_principal_id) as [role] 
--into ##tmp3
from ##tmp2 a
join sys.database_role_members b
on User_id(a.[user])=b.member_principal_id 
--select * from ##tmp3
---------------------------------------------------------



-------------------------запускаем на другой базе
declare @user nvarchar(30)
declare @login nvarchar(30)
declare @sql nvarchar(100)
declare @role nvarchar(100)
declare @sql2 nvarchar(100)


declare  [cursor] cursor local 
for
select [user],[login] from ##tmp2 

open [cursor] 

fetch next  from [cursor]
into @user,@login 

while(@@FETCH_STATUS=0)
				begin
								 set @sql=N'CREATE USER ['+@user+'] for login '+@login
									exec sp_executesql @sql

									declare cursor2 cursor local 
									for 
									select [user],[role] from ##tmp3  where [user]=@user
									
									open cursor2

									fetch next from cursor2
									into @user,@role
									while(@@FETCH_STATUS=0)
												begin
														set @sql2=N'ALTER ROLE ['+@role+'] add member '+@user
														exec sp_executesql @sql2		
												fetch next from cursor2
												into @user,@role
												end
								close [cursor2]
								deallocate [cursor2]
											
									fetch next from [cursor]
									into @user,@login 
				end
close [cursor]
deallocate [cursor]


select * from sys.database_principals
select* from sys.database_role_members