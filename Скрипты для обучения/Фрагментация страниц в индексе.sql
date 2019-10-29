USE AdventureWorks2014


/* из серии уроков "работа с индексами"
-------------------------------------------*/


--найдеам класстерный индекс Person.Person
select 
 fragment_count
,page_count
,avg_fragmentation_in_percent
,* 
from sys.dm_db_index_physical_stats(db_id(),	object_id('Person.Person'),1,NULL, 'Detailed')
--fragment_count это количесвто узлов на уровне
--avg_fragmentation_in_percent средняя фрагментация в процентах
--показывает долю неупорядоченных страниц у которых нарушвется порядок ID если их отсортировать по значению ключа.
--попробуем это проверить


--найдеам класстерный индекс Person.Person
--его корневой узел
select 
 allocated_page_file_id
,allocated_page_page_id
,index_id
,page_level
,* from sys.dm_db_database_page_allocations(7,OBJECT_ID('Person.Person'),1,null,'DETAILED')
order by 4 desc



DBCC PAGE(AdventureWorks2014,1,903,3)
--как видно порядок нарущен полностью, поэтому фрагментация 100 процентов из предпоследней выборки
--спустимся на уровень ниже

DBCC PAGE(AdventureWorks2014,1,916,3)
--можно переюирать много страниц и не заметить расхождение в порядке ID страниц
-- из предпоследней выборки фрагментация была 0.18 % , чему можно верить