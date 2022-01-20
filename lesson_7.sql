-- task_1
select name
from users
where id in (select user_id from orders);

-- task_2
select p.name, c.name 
from products p 
join catalogs c
on c.id=p.catalog_id; 

-- task_3
select id as flight_id,
	(select name from cities where label = `from`) AS `from`,
	(select name from cities where label = `to`) AS `to`
from flights
order by flight_id;