USE My_BASE
GO



--Создаем таблицу в своей базе на основе [AdventureWorks].[Person].[Person]
select [BusinessEntityID],[PersonType],[Title],[FirstName],[MiddleName],[LastName] 
into Person from [AdventureWorks].[Person].[Person]
--вставилось 19972 строк

--смотрим есть ли какие либо статистики для таблицы 
select * from sys.stats where object_id = OBJECT_ID('[dbo].[Person]')

--их нет
--теперь выполним запрос с предикатом
select * from Person where BusinessEntityID=50


--смотрим есть ли какие либо статистики  теперь
select * from sys.stats where object_id = OBJECT_ID('[dbo].[Person]')

--она появилась. Сервер автоматически создает статистику если ее нет после первого фиотрованного запроса или джойна
--запомним айдишник статистики и адишник 
declare @stats_name nvarchar(100)
select @stats_name=name from sys.stats where object_id = OBJECT_ID('[dbo].[Person]')

DBCC  SHOW_STATISTICS ('[dbo].[Person]',@stats_name)


--all density = 5,00701E-05
--сравним это число с резултатом запроса
select 1/(select cast(count(distinct [BusinessEntityID]) as decimal(19,10)) from Person)



--Range_hi_key -это врехняя граница шага. Кол-во шагов server считает по статистическому алгоритму максимальных расзностей.
--Range_Rows это число строк до Range_hi_key, не включая Range_hi_key
--Eq rows - это число значений равных Range_hi_key
--Distinct_Range_Rows это число различных значений до Range_hi_key, не включая Range_hi_key
--Avf_Range_rows -- cреднее число уникальных значений на данныq шаг.Range_Rows/Distinct_Range_Rows


--Создадим фильтрованную статистику на столбец [BusinessEntityID]
CREATE STATISTICS BusinessEntityID_stat_filtered
ON Person  ([BusinessEntityID])
where [BusinessEntityID]<9090
with FULLSCAN

--посмотрим статистики
select * from sys.stats where object_id = OBJECT_ID('[dbo].[Person]')
--ее номер 3 или тот, который у вас показан


DBCC SHOW_STATISTICS ('[dbo].[Person]',BusinessEntityID_stat_filtered)
--unfiltered rows показывает общее кол-во строк
--остальное тоже самое, просто это статистика для меньшей выборки нежели предыдущей
