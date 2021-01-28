-- Consider the following schema for a Library Database: 
-- BOOK(Book_id, Title, Publisher_Name, Pub_Year) 
-- BOOK_AUTHORS(Book_id, Author_Name) 
-- PUBLISHER(Name, Address, Phone) 
-- BOOK_COPIES(Book_id, Programme_id, No-of_Copies) 
-- BOOK_LENDING(Book_id, Programme_id, Card_No, Date_Out, Due_Date) 
-- LIBRARY_PROGRAMME(Programme_id, Programme_Name, Address) 
-- Write SQL queries to 
-- 1. Retrieve details of all books in the library – id, title, name of publisher, authors, number of copies in each Programme, etc. 
-- 2. Get the particulars of borrowers who have borrowed more than 3 books, but from Jan 2017 to Jun 2017. 
-- 3. Delete a book in BOOK table. Update the contents of other tables to reflect this data manipulation operation.   
-- 4. Partition the BOOK table based on year of publication. Demonstrate its working with a simple query. 
-- 5. Create a view of all books and its number of copies that are currently available in the Library.


create database tw1;

use tw1;

create table publisher( pname varchar(20),
	paddr varchar(20),
    phno int,
    primary key(pname)
);

create table book(
	book_id int,
    title varchar(20),
    pname varchar(20),
    pyear int,
    primary key(book_id),
    foreign key(pname) references publisher(pname)
);
 
 create table book_authors(
	book_id int,
    aname varchar(20),
    primary key(book_id,aname),
    foreign key(book_id) references book(book_id)
);

create table program(
	program_id int,
    program_name varchar(20),
    baddr varchar(20),
    primary key(program_id)
);

create table book_copies(book_id int,
	program_id int,
    no_of_copies int,
    primary key(book_id,program_id),
    foreign key(book_id) references book(book_id),
    foreign key(program_id)references program(program_id)
);

create table book_lending(
	book_id int,
    program_id int,
    card_no int,
    date_out Date,
    due_date date,
    primary key(book_id, program_id,card_no),
    foreign key(book_id)references book(book_id),
    foreign key(program_id)references program(program_id)
);

insert into publisher values('Ravi','Hubli',230272);
insert into publisher values('Anu','Gokak',231175);
insert into publisher values('Ramesh','Delhi',230008);
insert into publisher values('Prabha','Belgaum',230145);
insert into publisher values('Suresh','bellary',230105);

select * from publisher;

insert into book values(111,'dbms','Ravi',2001);
insert into book values(222,'cn','Anu',2000);
insert into book values(333,'java','Ramesh',2005);
insert into book values(444,'atci','Prabha',2003);
insert into book values(555,'me','Suresh',2001);

select * from book;

insert into book_authors values(111,'a1');
insert into book_authors values(222,'a2');
insert into book_authors values(333,'a3');
insert into book_authors values(444,'a4');
insert into book_authors values(555,'a5');

select * from book_authors;

insert into program values(1,'cs','baddr1');
insert into program values(2,'ec','baddr2');
insert into program values(3,'ee','baddr3');
insert into program values(4,'mech','baddr4');
insert into program values(5,'cv','baddr5');

select * from program;

insert into book_copies values(111,1,10);
insert into book_copies values(222,2,15);
insert into book_copies values(333,3,10);
insert into book_copies values(444,4,20);
insert into book_copies values(555,5,15);

select * from book_copies;

insert into book_lending values(111,1,123,'2017-01-01','2017-03-01');
insert into book_lending values(222,2,121,'2017-01-01','2017-06-30');
insert into book_lending values(333,3,123,'2017-01-01','2017-06-30');
insert into book_lending values(444,4,123,'2017-01-01','2017-06-30');
insert into book_lending values(555,5,120,'2017-01-01','2017-03-30');

select * from book_lending;

-- 1
select bc.program_id,bc.book_id,bk.title,bk.pname,ba.aname,bc.no_of_copies
from book bk,book_copies bc,book_authors ba
where bc.book_id=bk.book_id and ba.book_id=bk.book_id;

-- 2
select card_no
from book_lending
where date_out between '2017-01-01' and '2017-06-30'
group by card_no
having count(*)>3;

-- 3
delete from book_lending where book_id=222;
delete from book_copies where book_id=222;
delete from book_authors where book_id=222;
delete from book where book_id=222;

-- 4
create view year_of_publication as
select * from book where pyear=2001;

select * from year_of_publication;

-- 5
create view curavailablebooks as	
select B.book_id,B.title,C.no_of_copies from 
book B,book_copies C where B.book_id=C.book_id;

select * from curavailablebooks;
