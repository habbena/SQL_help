------------------------------
-- Даты
------------------------------

select dateadd(DD, +30, getdate()) -- выбрать дату через 30 дней от сегодня
select dateadd(DD, -30, getdate()) -- выбрать дату за 30 дней от сегодня

select datediff(DD, '2024-01-29', '2024-02-23') - разница между двумя датами

