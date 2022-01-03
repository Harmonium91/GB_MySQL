use vk;

create table friends_list (
	user_id BIGINT UNSIGNED NOT null,
	friend_id BIGINT UNSIGNED NOT null,
	created_at DATETIME default NOW(),

	PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (friend_id) REFERENCES users(id)
); -- —писок друзей пользовател€

ALTER TABLE friends_list 
ADD check (user_id <> friend_id); -- ѕользователь не может быть сам у себ€ в друзь€х


create table bookmark (
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED, 
	target_user_id BIGINT UNSIGNED,
	created_at DATETIME DEFAULT NOW(),
	
	FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id), 
    FOREIGN KEY (media_id) REFERENCES media(id),
    CHECK (user_id <> target_user_id)
); -- «акладки пользовател€

ALTER TABLE bookmark 
ADD check (user_id <> target_user_id); -- ѕользователь не может сам себ€ добавить в закладки

ALTER TABLE bookmark 
ADD check (media_id is not null OR target_user_id is not null); -- ¬ случае создани€ закладки, в ней должна содержатьс€ ссылка на пользовател€ или на медиа


create table wall (
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	header varchar(100) not null,
	body_text text,
	media_id BIGINT unsigned,
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    
    key wall_header_idx(header),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
); -- —тена пользовател€, в которой публикуютс€ различные записи