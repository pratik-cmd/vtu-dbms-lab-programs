-- Consider the following schema for Order Database: 
-- SALESMAN(Salesman_id, Name, City, Commission) 
-- CUSTOMER(Customer_id, Cust_Name, City, Grade, Salesman_id) 
-- ORDERS(Ord_No, Purchase_Amt, Ord_Date, Customer_id, Salesman_id) 
-- Write SQL queries to 
-- 1. Count the customers with grades above Bangalore’s average. 
-- 2. Find the name and numbers of all salesman who had more than one customer. 
-- 3. List all the salesman and indicate those who have and don’t have customers in their cities (Use UNION operation.) 
-- 4. Create a view that finds the salesman who has the customer with the highest order of a day. 
-- 5. Demonstrate the DELETE operation by removing salesman with id 1000. All his orders must also be deleted. 


create database tw2;

use tw2;

create table salesman(sid int,
	sname varchar(20),
	city varchar(20),
	commission int,
	primary key(sid)
);

create table customers(cid int,
	cname varchar(20),
    city varchar(20),
    grade int,
    sid int,
    primary key(cid),
    foreign key(sid) references salesman(sid)
);

create table orders(ordno int,
pamt int,
ord_date date,
cid int,
sid int,
primary key(ordno),
foreign key(sid) references salesman(sid),
foreign key(cid) references customers(cid)
);

insert into salesman values(1000,'amit','belgaum',100);
insert into salesman values(1001,'bhavana','banglore',90);
insert into salesman values(1002,'divya','hubli',90);
insert into salesman values(1003,'anil','pune',100);
insert into salesman values(1004,'sunil','pune',100);

select * from salesman;

insert into customers values(11, 'ravi', 'banglore', 8,1000);
insert into customers values(12, 'raghu', 'banglore', 8,1001);
insert into customers values(13, 'anil', 'belgaum', 6,1002);
insert into customers values(14, 'vishal', 'goa', 7,1002);
insert into customers values(15, 'ram', 'goa', 9,1003);
insert into customers values(16, 'amar', 'goa', 10,1001);

insert into orders values(111,4000,'2017-08-22',11,1000);
insert into orders values(222,5000,'2017-08-22',12,1001);
insert into orders values(333,7000,'2017-08-22',12,1002);
insert into orders values(444,7000,'2017-08-22',13,1002);
insert into orders values(555,7000,'2017-08-22',13,1001);

select * from orders;

-- queries
-- 1
select count(*)
from customers
where grade>(
select avg(grade)
from customers
where city='banglore');


-- 2
select c.sid, s.sname
from customers c, salesman s 
where s.sid=c.sid 
group by c.sid 
having count(*)>1;


-- 3
(select s.sid,s.sname,c.cname,s.city 
from salesman s, customers c
where c.sid=s.sid and c.city=s.city)
union
(select s.sid,s.sname,c.cname,'No match'
from salesman s,customers c
where c.sid=s.sid and c.city!=s.city);

-- 4
create view highest_order as
(select distinct o.sid,s.sname
from orders o, salesman s
where s.sid=o.sid and
pamt=(select max(pamt) from orders where ord_date='2017-08-22'));


select * from highest_order;

-- 5
delete from orders where sid=1000;
delete from customers where sid=1000;
delete from salesman where sid=1000;