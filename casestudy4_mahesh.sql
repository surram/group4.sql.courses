------T Mahesh babu---------casestudy4--------group4

create database casestudy
use casestudy


---1st Table
create table Courses(CID INT primary key,CNAME varchar(10) not null,shifts varchar(20) check(shifts in('Morning','Evening')),Fees smallmoney not null) 
insert into Courses values(1,'java','Morning',18000)
insert into Courses values(2,'Sql','Morning',18000.5790)
insert into Courses values(3,'.Net','Evening',20000)
insert into Courses values(4,'webTech','Evening',15000)
insert into Courses values(5,'html','Morning',1000)

select * from Courses


---2nd Table

create table Students(SID INT primary key,SNAME varchar(10) not null,ORIGIN char(1) check(ORIGIN IN('L','F')),TYPE char(1) check(TYPE IN('N','F')))
insert into Students values(1,'Hema','L','N')
insert into Students values(2,'Ramya','F','F')
insert into Students values(3,'Dhanusri','F','F')
insert into Students values(4,'Nitya','F','F')
insert into Students values(5,'Navya','L','F')
insert into Students values(6,'mahesh','F','F')
insert into Students values(7,'rakesh','F','F')

select * from Students

--3rd Table
create table Admissions(SID INT foreign key References Students(SID),CID INT foreign key References Courses(CID),DOJ datetime check(DOJ>='2020/01/01' AND DOJ<='2020/01/20'),GRADE char(1) check(Grade in('A','B','C')))
insert into Admissions values(1,1,'2020/01/10','A')
insert into Admissions values(2,2,'2020/01/15','B')
insert into Admissions values(3,2,'2020/01/10','A')
insert into Admissions values(4,3,'2020/01/12','A')
insert into Admissions values(5,2,'2020/01/10','C')
insert into Admissions values(6,'2020/01/15','B')

insert into Admissions values(7,3,'2020/01/15','A')


--select * from (select * from Courses inner join Admissions on  Courses.CID = Admissions.CID)  

select * from Admissions
select * from Students
select * from Courses

--1)List the No.of students based on course wise.
SELECT CID,COUNT(SID) AS NUMBEROFSTUDENTS  FROM ADMISSIONS GROUP BY CID

--List the student details which student origin Is foreign and no.of values exceeds 10?
select * from Students where origin like 'F' and (select count(SID) from Students where ORIGIN like 'F') > 4

--2)List the Student,Course,Admissions details which student taken some course ?
SELECT STUDENTS.*,COURSES.*,ADMISSIONS.*   FROM STUDENTS 
INNER JOIN ADMISSIONS ON STUDENTS.SID=ADMISSIONS.SID  
INNER JOIN COURSES ON COURSES.CID=ADMISSIONS.CID

--3)List the all Student name which students grade is ‘A’ and “B’?
go
select s.SNAME, a.GRADE from students s inner join Admissions a on s.sid = a.sid 
 where  a.grade  in (select grade from Admissions where grade = 'A' or grade = 'B' ) 

 go
 SELECT SNAME FROM STUDENTS WHERE SID 
IN(SELECT SID FROM ADMISSIONS WHERE GRADE IN('A','B'))
select * from Admissions

--4)List the Course details which course does not have any students?
select * from Courses c where  cid not in (select cid from Admissions)

select * from Courses where not exists (select cid from Admissions where Admissions.cid= courses.CID)

SELECT * FROM COURSES WHERE NOT EXISTS (SELECT 1 FROM ADMISSIONS WHERE ADMISSIONS.CID=COURSES.CID)


--6)Insert,Update,Delete records into students table using Procedure?
go
create proc insertstutable(@op int,@sid int,@sname varchar(20),@origin char(1),@type char(1))
as
begin
if(@op=1)
insert into Students values(@sid,@sname,@origin,@type)
else if(@op=2)
update Students set sid=@sid ,sname = @sname , ORIGIN =@origin , type = @type where sid=@sid
else if(@op=3)
delete from Students where sid=@sid and sname = @sname and ORIGIN =@origin and type = @type
else
print 'not valid op code select 1 for insert , 2 for update, 3 for delete '
end

		go
		exec insertstutable 1,9,'bi','L','F'
		exec insertstutable 2,9,'bin','F','N'
       exec insertstutable 3,9,'bin','F','N'
	   select * from Students





--7)List which course is taken maximum number of students?
select * from Courses where CID =
(SELECT c.CID FROM Admissions A, Courses c WHERE A.CID = c.CID
GROUP BY c.CID
HAVING count(*) =
(SELECT MAX (mycount) FROM
(SELECT COUNT(*) mycount FROM Admissions
GROUP BY CID) a))


	













