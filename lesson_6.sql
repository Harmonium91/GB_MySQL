-- task_1
select from_user_id as user_id, count(from_user_id) as total_messages 
from messages 
where to_user_id = 1 --  
group by from_user_id
order by total_messages desc 
limit 1;

-- task_2
select count(id) as total_likes
from likes
where user_id in (
select user_id 
from profiles
where timestampdiff(year, birthday, now()) < 18
);

-- task_3
select case(gender)
when 'm' then 'male'
when 'f' then 'female'
end gender,
count(l.user_id) as total_likes
from profiles p join likes l 
where p.user_id = l.user_id
group by gender
order by total_likes desc
limit 1;
