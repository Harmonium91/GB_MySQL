-- task_1
select name, max(total_message) total_message
from (
		select concat(u1.firstname, ' ', u1.lastname) name, count(*) as total_message
		from messages m
		join users u1 on u1.id = m.from_user_id
		join users u2 on u2.id = m.to_user_id
		where m.to_user_id = 1
		group by u1.firstname 
	 ) as list;

-- task_2
select concat(firstname, ' ', lastname) Name, 
	   timestampdiff(year, p.birthday, now()) Age,
	   count(*) Total_message
from users u 
	join likes l on u.id = l.user_id 
	join profiles p on u.id = p.user_id
where timestampdiff(year, p.birthday, now()) < 10
group by u.id;

-- task_3
select case(gender)
	   when 'm' then 'male'
	   when 'f' then 'female'
	   end gender,
max(total_likes) Total_likes
from (
		select p.gender, count(*) as total_likes 
		from users u 
		join likes l on u.id = l.user_id
		join profiles p on u.id = p.user_id
		group by p.gender 
	  ) as list;