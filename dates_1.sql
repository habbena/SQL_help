-- ДАТЫ, ВРЕМЯ
----------------------------------------------------------------------------------
-- Извлечение части от даты (год, месяц, день, час, мин, сек)
-- Возможно 2 синтаксиса:
----------------------------------------------------------------------------------

SELECT date_part('month', now())::int,
		EXTRACT(MONTH FROM now())
		
		
/*
date_part|extract|
---------+-------+
        9|      9|
*/
		

SELECT EXTRACT(DOW FROM now()) AS day_of_week
/*
day_of_week|
-----------+
          4|
 */

----------------------------------------------------------------------------------
-- Округление даты до заданной части времени 
----------------------------------------------------------------------------------		
SELECT date_trunc('month', now()) 
/*
date_trunc                   |
-----------------------------+
2023-09-01 00:00:00.000 +0300|
*/


/*
ВАЖНО!!!!
date_part извлекает число. Например есть данные продаж за год, используя date_part('day', sales_date) 
мы получим всего 31 строку,
а используя date_trunc('day', sales_date) получим кол-во дней всего, когда были продажи. 
*/

----------------------------------------------------------------------------------
-- Приведение числа, обозначающего месяц или день недели к текстовому обозначению
----------------------------------------------------------------------------------

SELECT to_char(now(), 'day') AS day_of_week
/*
day_of_week|
-----------+
thursday   |
*/


SELECT to_char(now(), 'month') AS "month"
/*
month    |
---------+
september|
 */


--ВАЖНО!!! EXTRACT сортирует по порядку, to_char - сортирует по алфавиту
--чтобы избежать путуницы, надо группировать по обоим функциям, 
--а сортировать по EXTRACT


----------------------------------------------------------------------------------
-- Генерация списка дат
----------------------------------------------------------------------------------
SELECT generate_series('2023-09-01', 
						'2023-09-10', 
						'1 day'::interval)::date AS date
/*
date      |
----------+
2023-09-01|
2023-09-02|
2023-09-03|
2023-09-04|
2023-09-05|
2023-09-06|
2023-09-07|
2023-09-08|
2023-09-09|
2023-09-10|
*/


--Внимание!!!! Генерация последних дней месяца

SELECT (generate_series('2023-02-01', 
						'2024-01-01', 
						'1 month'::interval) - '1 day'::INTERVAL)::date

----------------------------------------------------------------------------------						
-- Посчитать разницу между двумя соседними датами в одном столбце
----------------------------------------------------------------------------------
WITH tmp (time, amount) AS (
	VALUES 
	('2023-09-11 09:15:00'::timestamp, 3::int),
	('2023-09-11 09:16:00', 12),
	('2023-09-11 09:19:00', 4),
	('2023-09-11 09:25:00', 4),
	('2023-09-11 09:26:00', 10),
	('2023-09-11 09:28:00', 5),
	('2023-09-11 09:33:00', 7),
	('2023-09-11 09:37:00', 5),
	('2023-09-11 09:41:00', 4),
	('2023-09-11 09:45:00', 3),
	('2023-09-11 09:52:00', 3)
)
SELECT 
	time, 
	LAG(time) OVER (ORDER BY time) AS previous_time,
	time - LAG(time) OVER (ORDER BY time) AS delta1,
	time,
	lead(time) OVER (ORDER BY time ) AS next_time,
	time - lead(time) OVER (ORDER BY time) AS delta2
FROM tmp
												
/*
time                   |previous_time          |delta1  |time                   |next_time              |delta2   |
-----------------------+-----------------------+--------+-----------------------+-----------------------+---------+
2023-09-11 09:15:00.000|                       |        |2023-09-11 09:15:00.000|2023-09-11 09:16:00.000|-00:01:00|
2023-09-11 09:16:00.000|2023-09-11 09:15:00.000|00:01:00|2023-09-11 09:16:00.000|2023-09-11 09:19:00.000|-00:03:00|
2023-09-11 09:19:00.000|2023-09-11 09:16:00.000|00:03:00|2023-09-11 09:19:00.000|2023-09-11 09:25:00.000|-00:06:00|
2023-09-11 09:25:00.000|2023-09-11 09:19:00.000|00:06:00|2023-09-11 09:25:00.000|2023-09-11 09:26:00.000|-00:01:00|
2023-09-11 09:26:00.000|2023-09-11 09:25:00.000|00:01:00|2023-09-11 09:26:00.000|2023-09-11 09:28:00.000|-00:02:00|
2023-09-11 09:28:00.000|2023-09-11 09:26:00.000|00:02:00|2023-09-11 09:28:00.000|2023-09-11 09:33:00.000|-00:05:00|
2023-09-11 09:33:00.000|2023-09-11 09:28:00.000|00:05:00|2023-09-11 09:33:00.000|2023-09-11 09:37:00.000|-00:04:00|
2023-09-11 09:37:00.000|2023-09-11 09:33:00.000|00:04:00|2023-09-11 09:37:00.000|2023-09-11 09:41:00.000|-00:04:00|
2023-09-11 09:41:00.000|2023-09-11 09:37:00.000|00:04:00|2023-09-11 09:41:00.000|2023-09-11 09:45:00.000|-00:04:00|
2023-09-11 09:45:00.000|2023-09-11 09:41:00.000|00:04:00|2023-09-11 09:45:00.000|2023-09-11 09:52:00.000|-00:07:00|
2023-09-11 09:52:00.000|2023-09-11 09:45:00.000|00:07:00|2023-09-11 09:52:00.000|                       |         |					
*/						
						
						
----------------------------------------------------------------------------------						
	-- ЗАДАЧИ					
----------------------------------------------------------------------------------						
-- 1. Вывести продажи помесячно, включая месяца, где не было продаж

WITH tmp (sales_date, sales) AS (
	VALUES 
	('2023-01-01'::date, 200::int),
	('2023-03-01', 100),
	('2023-04-01', 300),
	('2023-05-01', 200),
	('2023-10-01', 800)
),
months AS (
SELECT (generate_series('2023-01-01', 
						'2023-12-01', 
						'1 month'::interval))::date  AS "month")
SELECT "month", sales
FROM months
LEFT JOIN tmp ON sales_date = "month"	
/*
month     |sales|
----------+-----+
2023-01-01|  200|
2023-02-01|     |
2023-03-01|  100|
2023-04-01|  300|
2023-05-01|  200|
2023-06-01|     |
2023-07-01|     |
2023-08-01|     |
2023-09-01|     |
2023-10-01|  800|
2023-11-01|     |
2023-12-01|     |
 */	

-- 2. Определить в какие месяцы не было продаж

WITH tmp (sales_date, sales) AS (
	VALUES 
	('2023-01-01'::date, 200::int),
	('2023-03-01', 100),
	('2023-04-01', 300),
	('2023-05-01', 200),
	('2023-10-01', 800)
),
months AS (
SELECT (generate_series('2023-01-01', 
						'2023-12-01', 
						'1 month'::interval))::date  AS "month")
SELECT "month"
FROM months
WHERE MONTH NOT IN (
					SELECT sales_date FROM tmp)

/*
month     |
----------+
2023-02-01|
2023-06-01|
2023-07-01|
2023-08-01|
2023-09-01|
2023-11-01|
2023-12-01|
 */


-- 3. Сгенерировать интервалы времени и  посчитать сумму продаж за эти интервалы 

WITH gen AS (
SELECT 
	generate_series('2023-01-01 09:00:00',
					'2023-01-01 15:00:00', 
					'3 hours'::interval )  AS min_time,
	generate_series('2023-01-01 12:00:00',
					'2023-01-01 18:00:00', 
					'3 hours'::interval) AS max_time
),
tmp (sales_date, sales) AS (
	VALUES 
	('2023-01-01 09:13:15'::timestamp, 200::int),
	('2023-01-01 09:45:30', 100),
	('2023-01-01 13:45:34', 300),
	('2023-01-01 12:45:14', 300),
	('2023-01-01 14:45:34', 300),
	('2023-01-01 15:45:22', 300),
	('2023-01-01 15:45:12', 300)
)
SELECT 
	min_time, 
	max_time, 
	sum(sales)
FROM gen
LEFT JOIN tmp ON sales_date >= min_time AND 
				sales_date < max_time
GROUP BY  min_time, max_time
ORDER BY 1, 2

/*
min_time                     |max_time                     |sum|
-----------------------------+-----------------------------+---+
2023-01-01 09:00:00.000 +0300|2023-01-01 12:00:00.000 +0300|300|
2023-01-01 12:00:00.000 +0300|2023-01-01 15:00:00.000 +0300|900|
2023-01-01 15:00:00.000 +0300|2023-01-01 18:00:00.000 +0300|600|
 */


-- 4. Рассчитать максимальное время между продажами
-- 4.1. В подзапросе посчитать разницу между двумя соседними датами в одном столбце
-- 4.2. Вывести из подзапроса максимум


WITH tmp (sales_date, amount) AS (
	VALUES 
	('2023-09-11 09:15:00'::timestamp, 3::int),
	('2023-09-11 09:16:00', 12),
	('2023-09-11 09:19:00', 4),
	('2023-09-11 09:25:00', 4),
	('2023-09-11 09:26:00', 10),
	('2023-09-11 09:28:00', 5),
	('2023-09-11 09:33:00', 7),
	('2023-09-11 09:37:00', 5),
	('2023-09-11 09:41:00', 4),
	('2023-09-11 09:45:00', 3),
	('2023-09-11 09:52:00', 3)
)
SELECT 
	max(gap)
FROM 
	(SELECT 
			sales_date - lag(sales_date) OVER (ORDER BY sales_date) AS gap
	FROM tmp) AS res

/*
max     |
--------+
00:07:00|
*/


-- 5. Посмотреть разницу продаж по месяцам

WITH tmp (sales_date, sales) AS (
	VALUES 
	('2023-01-01'::date, 200::int),
	('2023-02-01', 100),
	('2023-03-01', 300),
	('2023-04-01', 200),
	('2023-05-01', 800)
)
SELECT 
	to_char(sales_date, 'Month') AS "month",
	sales,
	sales - lag(sales) OVER (ORDER BY sales_date) AS delta
FROM tmp
/*
month    |sales|delta|
---------+-----+-----+
January  |  200|     |
February |  100| -100|
March    |  300|  200|
April    |  200| -100|
May      |  800|  600|
 */




















	
