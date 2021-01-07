-- Consider the schema for Movie Database: 
-- ACTOR(Act_id, Act_Name, Act_Gender)
-- DIRECTOR(Dir_id, Dir_Name, Dir_Phone)
-- MOVIES(Mov_id, Mov_Title, Mov_Year, Mov_Lang, Dir_id) 
-- MOVIE_CAST(Act_id, Mov_id, Role) RATING(Mov_id, Rev_Stars) 
-- Write SQL queries to 
-- 1. List the titles of all movies directed by ‘Hitchcock’. 
-- 2. Find the movie names where one or more actors acted in two or more movies.
--  3. List all actors who acted in a movie before 2000 and also in a movie after 2015 (use JOIN operation).
--  4. Find the title of movies and number of stars for each movie that has at least one rating and find the highest number of stars that movie received. Sort the result by movie title. 
--  5. Update rating of all movies directed by ‘Steven Spielberg’ to 5.



create database tw3;

use tw3;

create table actor(
	act_id int,
    act_name varchar(20),
    act_gender char(1),
    primary key(act_id)
);

create table director(
	did int,
    dname varchar(20),
    dphone int,
    primary key(did)
);

create table movies(
	mid int,
    mtitle varchar(20),
    myear int,
    mlang varchar(20),
    did int,
    primary key(mid),
    foreign key(did) references director(did));
    
create table movie_cast(
	act_id int,
    mid int,
    role varchar(10),
    primary key(act_id,mid),
    foreign key(act_id) references actor(act_id),
    foreign key(mid) references movies(mid)
);

create table rating(
	mid int,
    rev_stars int,
    foreign key(mid) references movies(mid)
);

insert into actor values(1,'Anushka','f');
insert into actor values(2,'Prabhas','m');
insert into actor values(3,'Deepika','f');
insert into actor values(4,'Punith','m');
insert into actor values(5,'Yash','m');

insert into director values(51,'Raj',98724132);
insert into director values(52,'Faran',91912433);
insert into director values(53,'Steven spielberg',81823410);
insert into director values(54,'Hitchcock',73210638);
insert into director values(55,'Prem',61321140);

insert into movies values(1000,'War house',1999,'English',53);
insert into movies values(1001,'KGF',2016,'Hindi',51);
insert into movies values(1002,'Joker',2009,'English',54);
insert into movies values(1003,'Badla',2010,'Hindi',52);
insert into movies values(1004,'Law',2005,'Kannada',55);
insert into movies values(1005,'Spider',2004,'English',54);

insert into movie_cast values(1,1003,'Heroine');
insert into movie_cast values(1,1001,'Heroine');
insert into movie_cast values(2,1000,'Hero');
insert into movie_cast values(4,1004,'Guest');
insert into movie_cast values(5,1000,'Hero');
insert into movie_cast values(5,1001,'Hero');
insert into movie_cast values(4,1003,'Hero');

insert into rating values(1000,3);
insert into rating values(1001,5);
insert into rating values(1002,3);
insert into rating values(1003,1);
insert into rating values(1004,2);
insert into rating values(1000,3);
insert into rating values(1002,2);
update rating set rev_stars=3 where mid=1000;

select * from rating;

-- 1
select m.mtitle
from movies m, director d
where d.did=m.did and dname='Hitchcock';

-- 2
select m.mtitle
from movies m, movie_cast mc
where m.mid=mc.mid and act_id in(select act_id from movie_cast
									group by act_id
                                    having count(act_id)>1)
group by mtitle
having count(*)>=1;


-- 3
select a.act_name,m.mtitle,m.myear
from actor a join movie_cast mc on a.act_id=mc.act_id join movies m on mc.mid=m.mid
where m.myear not between 2000 and 2015;

-- 4
select mtitle,max(rev_stars),sum(rev_stars)
from movies m, rating r
where m.mid=r.mid
group by mtitle
having max(rev_stars)>0
order by mtitle;

-- 5
update rating set rev_stars=5
where mid in( select mid 
			  from movies m, director d
              where m.did=d.did and dname='Steven spielberg');

select * from rating;