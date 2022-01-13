select distinct firstname
from users
order by firstname asc;

alter table profiles
add is_active BIT default 1;

update profiles 
set is_active = 0
where (TO_DAYS(NOW()) - TO_DAYS(birthday))/365.25 < 18;

delete from messages
where created_at > NOW();