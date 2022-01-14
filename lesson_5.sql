-- task_1_1
update users
set created_at = NOW(),
updated_at = NOW();


-- task_1_2
create table temp(
id serial,
name varchar(50),
created_at varchar(15),
updated_at varchar(15)
);

insert into temp
select id, name, created_at, updated_at
from users;

truncate table users;

ALTER TABLE users MODIFY COLUMN created_at DATETIME;
ALTER TABLE users MODIFY COLUMN updated_at DATETIME;

insert into users
select id, name, STR_TO_DATE(created_at, '%d.%m.%Y %l:%i'), STR_TO_DATE(created_at, '%d.%m.%Y %l:%i')
from temp;

DROP TABLE temp; -- task_1_2 end 


-- task_1_3
select * 
from storehouses_products
where value <> 0
union 
select * 
from storehouses_products
where value = 0;

-- task_1_4
select *
from users
where birthday_at = 'may' or 'august';

-- task_1_5
select *
from catalogs
where id in (5, 1, 2)
order by field(id, 5, 1, 2);

-- task_2_1
select avg(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS age
from users;

-- task_2_2
select dayname(concat(year(now()), '-', substring(birthday_at, 6, 10))) AS week_day,
       count(*) as birthday
from users
group by week_day
order by birthday desc;

-- task_2_3
select round(exp(sum(log(value))), 0) as factorial 
from test_table;