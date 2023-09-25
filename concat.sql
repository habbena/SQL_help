--Слияние и разделение 

----------------------------------------------------------------------------------
--Слияние
----------------------------------------------------------------------------------

WITH tmp (city, street, house) AS (
	VALUES 
	('Krasnodar', 'Budennogo', 196),
	('Krasnodar', 'Gavrilova', NULL)
)
SELECT 
	concat(city, ' ', street, ' ', house) AS adress
FROM tmp


/*
adress                 |
-----------------------+
Krasnodar Budennogo 196|
Krasnodar Gavrilova    |
*/

WITH tmp (city, street, house) AS (
	VALUES 
	('Krasnodar', 'Budennogo', 196),
	('Krasnodar', 'Gavrilova', NULL)
)
SELECT 
	city || ' ' || street || ' ' || house AS adress
FROM tmp

/*
adress                 |
-----------------------+
Krasnodar Budennogo 196|
                       |
*/

--ВАЖНО! В случае с двойной верттикальной чертой строки, при объединении ячеек, где есть NULL 
--объединение приводит к отсутвующему значению