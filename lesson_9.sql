-- task_1_1
start transaction;

insert into sample.users 
select * 
from shop.users 
where id = 1;

commit;

-- task_1_2
create view test (product_name, catalogs) as
	select p.name, c.name 
	from products p
		join catalogs c on p.catalog_id=c.id;

-- task_1_3
create table date_test (
	created_at date	
);

insert into date_test (created_at)
values ('2018-08-01'),
	   ('2018-08-04'),
	   ('2018-08-16'),
	   ('2018-08-17');

create temporary table list_date (
t_date date
); 

insert into list_date 
select time_period.selected_date 
	from
		  (select v.* 
		  from 
		  (select ADDDATE('2018-08-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) selected_date 
		   from
		  (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0,
		  (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1,
		  (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2,
	   	  (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3,
		  (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v
where selected_date between '2018-08-01' and '2018-08-31') as time_period;

set @rnk := 0;

select distinct t_date, 
case(@rnk)
	when t_date = created_at then @rnk = 1
	when t_date <> created_at then @rnk = 0
	end as test
from list_date 
	left join date_test on t_date = created_at
order by t_date;

-- task_1_4
create table temp (
	created_at date	
);

insert into temp (created_at)
values     ('2018-08-01'),
	   ('2018-08-02'),
	   ('2018-08-03'),
	   ('2018-08-04'),
	   ('2018-08-05'),
	   ('2018-08-06'),
	   ('2018-08-07'),
	   ('2018-08-08');

start transaction;

create temporary table var (
  new_date date
);

insert into var
select created_at
from temp
order by created_at desc
limit 5;

delete from temp
where created_at not in (
			 select new_date 
			 from var
			);

drop temporary table var;

commit;




-- task_2_1
create user shop_read;

create user shop;

grant select on shop.* to shop_read;

grant all on shop.* to shop;
grant grant option on shop.* to shop;

-- task_2_2
create table accounts(
id int,
name varchar(50),
`password` varchar(100)
);

create view username (id, name) as
	   select id, name 
	   from accounts;
	  
create user user_read;

grant select on username to user_read;



-- task_3_1
create function hello()
returns varchar(50) deterministic
begin
		declare h_out varchar(50);
			
		if(curtime() between '06:00:01' and '12:00:00') then
			set h_out = 'Доброе утро!';
		elseif(curtime() between '12:00:01' and '18:00:00') then
			set h_out = 'Добрый день!!';
		elseif(curtime() between '18:00:01' and '23:59:59') then
			set h_out = 'Добрый вечер!!';
		else
			set h_out = 'Доброй ночи!';
		end if;
		
	return (h_out);
	
end;

-- task_3_2
create trigger not_null_insert before insert on products
for each row 
	begin 
		if new.name is null and new.description is null
		then signal sqlstate '45000' set message_text = 'Внимание! Поля name и description не могут быть пустыми одновременно!'; 
		end if;
end;

create trigger not_null_update before update on products
for each row 
	begin 
		if new.name is null and new.description is null
		then signal sqlstate '45000' set message_text = 'Внимание! Поля name и description не могут быть пустыми одновременно!'; 
		end if;
end;

-- task_3_3
drop function fibonacci;

create function fibonacci(num int)
returns int deterministic
begin
	
	declare i int default 0;
	declare a int default 1;
	declare b int default 1;
	declare sum int;
	 if (num > 0) then
	 	while i < num - 2 do
	 	set sum = a + b;
	 	set a = b;
	 	set b = sum;
	 	set i = i +1;
	 	end while;
	 end if;
	return (sum);
end;
	

