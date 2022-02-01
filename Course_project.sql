create database railway;

use railway;

create table trains(
id serial,
stamp varchar(50),
van int,
registration_at datetime default now()
); -- в таблице хранятся сведения о поездах

create table machinists(
id serial,
surname varchar(50) not null,
name varchar(50) not null,
patronymic varchar(50),
birthday date not null,
gender enum('male', 'female'),
phone bigint unsigned unique,
license varchar(10) not null unique 
); -- в таблице хранятся сведения о машинистах

create table passengers(
id serial,
surname varchar(50) not null,
name varchar(50) not null,
patronymic varchar(50),
birthday date not null,
gender enum('male', 'female'),
phone bigint unsigned unique,
email varchar(100) unique
); -- в таблице хранятся сведения о пассажирах

create table stations(
id serial,
station_name varchar(40),
code varchar(3)
); -- в таблице хранятся сведения о станциях

create table routes(
id serial,
departure_station_id bigint unsigned not null,
arrival_station_id bigint unsigned not null,
distance int comment 'unit of measurement kilometers',
price decimal(7,2),
created_at datetime default now(),
updated_at datetime on update current_timestamp,

foreign key (departure_station_id) references stations(id) 
on update cascade on delete no action,
foreign key (arrival_station_id) references stations(id)
on update cascade on delete no action
); -- в таблице хранятся сведения о маршрутах и их стоимости

create table `assignment`(
id serial,
train_id bigint unsigned not null,
first_machinist_id bigint unsigned not null,
second_machinist_id bigint unsigned not null,
created_at datetime default now(),
updated_at datetime on update current_timestamp,
status enum('current', 'cancelled'),

foreign key (train_id) references trains(id) 
on update cascade on delete no action,
foreign key (first_machinist_id) references machinists(id)
on update cascade on delete no action,
foreign key (second_machinist_id) references machinists(id)
on update cascade on delete no action
); -- в таблице хранятся сведения о назначениях машинистов на поезда

create table schedule(
id serial,
train_id bigint unsigned not null,
route_id bigint unsigned not null,
departure_at datetime,
arrival_at datetime,
track_number char(1) not null,

foreign key (train_id) references trains(id) 
on update cascade on delete no action,
foreign key (route_id) references routes(id)
on update cascade on delete no action
); -- в таблице хранится расписание поездов

create table discounts(
id serial,
category varchar(50),
amount float
); -- в таблице хранятся сведения о льготах

create table additional_services(
id serial,
service_type varchar(50),
cost decimal(5,2)
); -- в таблице хранятся сведения о дополнительных услугах

create table tickets(
id serial,
schedule_id bigint unsigned not null,
passenger_id bigint unsigned not null,
discount_id bigint unsigned not null,
additional_service_id bigint unsigned not null,
created_at datetime default now(),
total_cost decimal(5,2),

foreign key (schedule_id) references schedule(id) 
on update cascade on delete no action,
foreign key (passenger_id) references passengers(id)
on update cascade on delete no action,
foreign key (discount_id) references discounts(id) 
on update cascade on delete no action,
foreign key (additional_service_id) references additional_services(id)
on update cascade on delete no action
); -- в таблице хранятся сведения о приобретенных билетах

alter table machinists
add index machinists_surname_birthday_idx (surname, birthday);

alter table passengers
add index passengers_surname_birthday_idx (surname, birthday);

alter table stations
add index stations_name_idx (station_name);

alter table routes
add index routes_price_idx (price);