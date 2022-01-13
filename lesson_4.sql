CREATE DATABASES vk;
USE vk;

CREATE TABLE users (
	id SERIAL, 
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия', 
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), 	
	phone BIGINT UNSIGNED UNIQUE, 
	
    INDEX users_firstname_lastname_idx(firstname, lastname)
);


CREATE TABLE profiles (
	user_id SERIAL,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100)
);

ALTER TABLE profiles ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE 
    ON DELETE RESTRICT;


CREATE TABLE messages (
	id SERIAL,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),

    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);


CREATE TABLE friend_requests (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    status ENUM('requested', 'approved', 'declined', 'unfriended'),
   	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)   
);


ALTER TABLE friend_requests 
ADD CHECK(initiator_user_id <> target_user_id);


CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name),
	foreign key (admin_user_id) references users(id)
);


CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255), 	
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);


CREATE TABLE likes(
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()

);

CREATE TABLE `photo_albums` (
	`id` SERIAL,
	`name` varchar(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (`id`)
);

CREATE TABLE `photos` (
	id SERIAL,
	`album_id` BIGINT unsigned NULL,
	`media_id` BIGINT unsigned NOT NULL,

	FOREIGN KEY (album_id) REFERENCES photo_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES vk.media(id);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES vk.users(id);

ALTER TABLE vk.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);


INSERT INTO vk.users (`id`,`firstname`,`lastname`,`email`,`password_hash`,`phone`)
VALUES
  (1,"Slade Berg","Sasha Peterson","adipiscing@yahoo.couk","%B3026112648350383^JcnsvxmQefeay^95111263?5","13616828668"),
  (2,"Willa Gardner","Cora White","purus.in.molestie@google.net","%B1256127167938571^UedrnohIcgvsc^3709711804?5","17647915743"),
  (3,"Martena Dillard","Hanna Blankenship","aliquet.nec@hotmail.edu","%B6237222626163585^JhyshzcJbyold^43037592?7","18268436816"),
  (4,"Armando Roach","Blake House","praesent.interdum.ligula@icloud.couk","%B9119984015785840^NgvckppHlqwku^53118624?1","11766766131"),
  (5,"Tasha Boyer","Myra Robbins","in@protonmail.com","%B3304882367368598^SdqejjbYeoopc^03059024?3","18064340495"),
  (6,"Hermione Mosley","Edan Whitaker","fames.ac@hotmail.org","%B7573351622509588^EyoculrLtopxv^4910306584?7","15179107342"),
  (7,"Leonard Walker","McKenzie Carr","et.malesuada@yahoo.com","%B4855227657344778^NjgvwgdXbzxog^0702458539?9","17587308858"),
  (8,"Beck Reeves","Virginia Santiago","proin@hotmail.org","%B7645250065175485^QjgwhcfCtmrmh^83012942?2","16687158852"),
  (9,"Nigel Potter","Jared Cain","velit.dui@google.edu","%B7502385436034476^DsljuauTsvoiv^2603549417?7","15533037893"),
  (10,"Amelia Berger","Nigel Flowers","nunc.ut@yahoo.couk","%B8699126041151411^NtejmmbOrhxlq^35012695010?6","18674314334");
  
INSERT INTO vk.profiles (`user_id`,`gender`,`birthday`,`photo_id`,`created_at`,`hometown`)
VALUES
  (1,"m","1974-01-23",1,"2021-01-13 21:17:22","diam."),
  (2,"f","1975-01-04",2,"2021-01-13 21:17:22","gravida"),
  (3,"f","1988-12-20",3,"2021-01-13 21:17:22","mauris."),
  (4,"f","2004-05-15",4,"2021-01-13 21:17:22","quis,"),
  (5,"m","2023-01-03",5,"2021-01-13 21:17:22","ac"),
  (6,"f","1969-11-09",6,"2021-01-13 21:17:22","tristique"),
  (7,"m","1974-09-03",7,"2021-01-13 21:17:22","Maecenas"),
  (8,"f","2001-12-19",8,"2021-01-13 21:17:22","enim."),
  (9,"f","2022-03-19",9,"2021-01-13 21:17:22","aliquam,"),
  (10,"f","2010-06-28",10,"2021-01-13 21:17:22","ultricies");
 
 
INSERT INTO vk.messages (`id`,`from_user_id`,`to_user_id`,`body`,`created_at`)
VALUES
  (1,1,6,"non magna. Nam ligula elit, pretium et, rutrum","2023-03-05 04:25:40"),
  (2,2,7,"elementum sem, vitae","2019-05-09 07:15:57"),
  (3,3,3,"Cras","2011-08-25 18:54:11"),
  (4,4,7,"sed dictum eleifend, nunc risus","2017-12-21 02:46:06"),
  (5,5,1,"eu arcu. Morbi sit amet massa. Quisque porttitor","2018-03-08 13:50:54"),
  (6,6,7,"dapibus quam quis diam. Pellentesque habitant morbi tristique senectus et","2018-07-22 09:18:52"),
  (7,7,10,"turpis egestas. Fusce aliquet magna a neque. Nullam","2011-07-06 09:59:38"),
  (8,8,8,"ligula. Aenean euismod mauris eu elit. Nulla","2014-06-01 06:20:35"),
  (9,9,3,"Cras sed leo. Cras vehicula aliquet libero.","2022-02-01 20:25:25"),
  (10,10,8,"Nam tempor diam dictum sapien.","2011-05-10 09:28:10");
  
INSERT INTO vk.friend_requests (`initiator_user_id`,`target_user_id`,`status`,`requested_at`,`updated_at`)
VALUES
  (1,6,"approved","2019-12-02 14:01:21","2019-09-26 13:07:05"),
  (2,3,"requested","2020-12-31 07:38:40","2019-05-06 15:10:22"),
  (3,6,"declined","2020-08-04 10:36:23","2019-03-07 15:29:18"),
  (4,6,"requested","2019-08-31 04:03:38","2019-03-02 11:41:55"),
  (5,9,"declined","2020-06-15 18:52:49","2019-02-28 21:15:49"),
  (6,7,"approved","2020-07-26 20:48:08","2020-03-08 02:10:36"),
  (7,5,"approved","2020-05-01 11:25:47","2020-08-02 11:21:48"),
  (8,3,"requested","2020-06-23 03:21:41","2020-02-08 15:17:44"),
  (9,10,"requested","2019-12-28 19:28:23","2019-11-06 02:56:07"),
  (10,6,"approved","2020-02-21 04:22:11","2019-10-23 06:40:46");
 
INSERT INTO vk.communities (`id`,`name`,`admin_user_id`)
VALUES
  (1,"Mauris",5),
  (2,"vulputate",2),
  (3,"mauris",8),
  (4,"auctor.",2),
  (5,"odio.",6),
  (6,"malesuada",3),
  (7,"dui",6),
  (8,"sit",8),
  (9,"ligula",4),
  (10,"Cras",9);
 
INSERT INTO vk.media_types (`id`,`name`,`created_at`,`updated_at`)
VALUES
  (1,"vitae erat vel","2018-12-14 09:37:04","2020-02-15 13:09:02"),
  (2,"euismod est arcu","2019-02-18 10:23:29","2020-07-10 07:14:41"),
  (3,"lobortis ultrices. Vivamus","2018-11-09 03:15:14","2020-10-30 11:48:30"),
  (4,"et tristique pellentesque, tellus","2020-03-21 08:05:49","2021-11-13 14:41:59"),
  (5,"non,","2018-04-08 06:06:22","2020-11-21 17:49:53"),
  (6,"feugiat. Lorem","2019-12-07 08:01:11","2020-12-21 09:15:35"),
  (7,"amet ante. Vivamus","2018-09-16 02:00:57","2021-08-20 12:16:39"),
  (8,"Donec luctus aliquet odio. Etiam","2018-07-26 01:33:24","2020-12-11 10:00:16"),
  (9,"mus. Proin vel arcu","2019-02-25 08:28:44","2020-11-22 01:55:13"),
  (10,"auctor, velit","2018-01-28 00:47:14","2020-06-04 05:37:40");

 
 
INSERT INTO vk.users_communities (`user_id`,`community_id`)
VALUES
  (1,7),
  (2,9),
  (3,4),
  (6,2),
  (7,3),
  (8,4),
  (9,5),
  (10,6),
  (4,10),
  (5,8);
  
INSERT INTO vk.media (`id`,`media_type_id`,`user_id`,`body`,`filename`,`size`,`created_at`,`updated_at`)
VALUES
  (1,3,6,"metus. Aliquam erat volutpat. Nulla facilisis. Suspendisse commodo tincidunt nibh. Phasellus nulla. Integer vulputate,","Martha Larson",1107,"2019-02-24 12:49:49","2020-05-17 21:17:55"),
  (2,9,9,"amet, consectetuer","Lane Dorsey",1461,"2019-10-03 06:00:56","2020-01-16 06:54:23"),
  (3,2,7,"in","Zena Oneil",1212,"2018-01-16 06:20:46","2020-09-16 10:51:37"),
  (4,9,7,"ultrices posuere cubilia Curae Phasellus ornare. Fusce mollis. Duis","Leroy O'Neill",1331,"2019-04-28 08:48:33","2020-12-24 02:22:37"),
  (5,2,8,"a neque. Nullam ut nisi a odio semper cursus. Integer mollis. Integer tincidunt","Brendan Sampson",1289,"2018-11-09 14:40:01","2020-03-09 01:26:31"),
  (6,8,4,"ipsum porta","Blossom Cabrera",1320,"2018-01-26 08:25:27","2020-08-26 07:24:19"),
  (7,6,9,"non sapien molestie orci tincidunt adipiscing. Mauris","Hector Hammond",1013,"2019-06-22 02:24:11","2021-01-10 04:22:30"),
  (8,5,6,"vel lectus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur","Gavin Vaughn",1450,"2019-12-25 09:44:48","2021-01-10 16:25:28"),
  (9,3,9,"Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac","Lyle Clayton",1074,"2019-05-25 20:11:31","2020-07-23 19:19:40"),
  (10,8,2,"Cras pellentesque. Sed dictum. Proin eget odio. Aliquam vulputate","Juliet Alvarado",1210,"2019-08-19 11:50:40","2020-03-26 20:20:41");

INSERT INTO vk.likes (`id`,`user_id`,`media_id`,`created_at`)
VALUES
  (1,2,9,"2019-02-18 08:04:32"),
  (2,7,8,"2019-08-30 15:41:04"),
  (3,7,8,"2019-10-01 10:36:45"),
  (4,5,7,"2018-08-05 07:23:59"),
  (5,5,8,"2018-05-04 17:05:04"),
  (6,2,10,"2019-11-29 15:30:19"),
  (7,3,1,"2018-04-10 10:59:01"),
  (8,5,3,"2018-07-14 14:42:26"),
  (9,5,7,"2018-12-18 23:32:25"),
  (10,1,1,"2019-04-14 17:09:57");
  
 
INSERT INTO vk.photo_albums (`id`,`name`,`user_id`)
VALUES
  (1,"Etiam",2),
  (2,"lacinia. Sed",4),
  (3,"ipsum",4),
  (4,"nulla. In",8),
  (5,"lectus quis massa.",7),
  (6,"Phasellus vitae mauris",9),
  (7,"quam. Pellentesque",5),
  (8,"erat",3),
  (9,"blandit mattis. Cras",4),
  (10,"Integer urna. Vivamus",4);
  
 
INSERT INTO vk.photos (`id`,`album_id`,`media_id`)
VALUES
  (1,9,4),
  (2,6,9),
  (3,8,3),
  (4,6,6),
  (5,2,2),
  (6,7,9),
  (7,1,2),
  (8,10,3),
  (9,10,2),
  (10,6,10);
