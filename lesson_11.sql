-- task_1
create table logs(
id bigint unsigned not null,
name varchar(255),
created_at datetime,
tbl_name varchar(50)
) engine=Archive;



create trigger catalogs_logs_to_archive
after insert on catalogs
for each row
	begin
		insert into shop.logs (id, name, created_at, tbl_name)
		select new.id, new.name, now(), 'catalogs'
		from catalogs
		where id = new.id;
	end;
	
create trigger products_logs_to_archive
after insert on products
for each row
	begin
		insert into shop.logs (id, name, created_at, tbl_name)
		select new.id, new.name, now(), 'products'
		from products
		where id = new.id;
	end;

create trigger users_logs_to_archive
after insert on users
for each row
	begin
		insert into shop.logs (id, name, created_at, tbl_name)
		select new.id, new.name, now(), 'users'
		from users
		where id = new.id;
	end;
	

-- task_2
create procedure mass_insert()
	begin
		declare i int default 0;
		declare a int default 7; 
		while i <= 1000000 do
			insert into shop.users (id, name, birthday_at)
			select a, substring('ABCDEFGHIJKLMNOPQRSTUVWXYZ', rand()*10, rand()*10),
				   current_date - interval floor(rand() * 250) day;
			set a = a + 1;
			set i = i + 1;
		end while;
	end;


call mass_insert()
