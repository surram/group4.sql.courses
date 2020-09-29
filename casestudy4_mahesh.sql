------T Mahesh babu---------casestudy4--------group4

create database casestudy
use casestudy

---------------------------------------------------------------------------------------------------------------------------------------------------------

---1st Table
create table Courses(CID INT primary key,CNAME varchar(10) not null,shifts varchar(20) check(shifts in('Morning','Evening')),Fees smallmoney not null) 
insert into Courses values(1,'java','Morning',18000)
insert into Courses values(2,'Sql','Morning',18000.5790)
insert into Courses values(3,'.Net','Evening',20000)
insert into Courses values(4,'webTech','Evening',15000)
insert into Courses values(5,'html','Morning',1000)

select * from Courses

-------------------------------------------------------------------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------------------------------------------------------------

--3rd Table
create table Admissions(SID INT foreign key References Students(SID),CID INT foreign key References Courses(CID),DOJ datetime check(DOJ>='2020/01/01' AND DOJ<='2020/01/20'),GRADE char(1) check(Grade in('A','B','C')))
insert into Admissions values(1,1,'2020/01/10','A')
insert into Admissions values(2,2,'2020/01/15','B')
insert into Admissions values(3,2,'2020/01/10','A')
insert into Admissions values(4,3,'2020/01/12','A')
insert into Admissions values(5,2,'2020/01/10','C')
insert into Admissions values(6,'2020/01/15','B')

insert into Admissions values(7,3,'2020/01/15','A')


select * from Admissions
select * from Students
select * from Courses
---------------------------------------------------------------------------------------------------------------------------------------------------------

--1)List the No.of students based on course wise.
SELECT CID,COUNT(SID) AS NUMBEROFSTUDENTS  FROM ADMISSIONS GROUP BY CID
/* output
CID	NUMBEROFSTUDENTS
1	1
2	3
3	1
*/


--List the student details which student origin Is foreign and no.of values exceeds 10?

--keeping 4 as per table values
select * from Students where origin like 'F' and (select count(SID) from Students where ORIGIN like 'F') > =3
/* output
SID	SNAME		ORIGIN	TYPE
2	Ramya		F	F
3	Dhanusri	F	F
4	Nitya		F	F
*/

----------------------------------------------------------------------------------------------------------------------------------------------------


--2)List the Student,Course,Admissions details which student taken some course ?
SELECT STUDENTS.*,COURSES.*,ADMISSIONS.*   FROM STUDENTS 
INNER JOIN ADMISSIONS ON STUDENTS.SID=ADMISSIONS.SID  
INNER JOIN COURSES ON COURSES.CID=ADMISSIONS.CID

/* output 

SID	SNAME	ORIGIN	TYPE	CID	CNAME	shifts	Fees	SID	CID	DOJ	GRADE
1	Hema	L	N	1	java	Morning	18000.00	1	1	2020-01-10 00:00:00.000	A
2	Ramya	F	F	2	Sql	Morning	18000.579	2	2	2020-01-15 00:00:00.000	B
3	Dhanusri	F	F	2	Sql	Morning	18000.579	3	2	2020-01-10 00:00:00.000	A
4	Nitya	F	F	3	.Net	Evening	20000.00	4	3	2020-01-12 00:00:00.000	A
5	Navya	L	F	2	Sql	Morning	18000.579	5	2	2020-01-10 00:00:00.000	C
*/


--------------------------------------------------------------------------------------------------------------------------------------------------------

--3)List the all Student name which students grade is ‘A’ and “B’?
go
select s.SNAME, a.GRADE from students s inner join Admissions a on s.sid = a.sid 
 where  a.grade  in (select grade from Admissions where grade = 'A' or grade = 'B' ) 

 /* 
 SNAME	GRADE
Hema	A
Ramya	B
Dhanusri	A
Nitya	A
 */

 go
 SELECT SNAME FROM STUDENTS WHERE SID 
IN(SELECT SID FROM ADMISSIONS WHERE GRADE IN('A','B'))

/* 
SNAME
Hema
Ramya
Dhanusri
Nitya
*/

------------------------------------------------------------------------------------------------------------------------------------------------------

--4)List the Course details which course does not have any students?
select * from Courses c where  cid not in (select cid from Admissions)
--or--
select * from Courses where not exists (select cid from Admissions where Admissions.cid= courses.CID)
--or--
SELECT * FROM COURSES WHERE NOT EXISTS (SELECT 1 FROM ADMISSIONS WHERE ADMISSIONS.CID=COURSES.CID)

/* output
CID	CNAME	shifts	Fees
4	webTech	Evening	15000.00
5	html	Morning	1000.00

*/

-------------------------------------------------------------------------------------------------------------------------------------------------------


--5)List the Fees details based on Student id which is more than 4000?
select a.SID, c.Fees  from Courses c inner join  Admissions a on c.CID = a.CID where c.Fees >4000

/* output
SID	Fees
1	18000.00
2	18000.579
3	18000.579
4	20000.00
5	18000.579
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------

--6)Insert,Update,Delete records into students table using Procedure?
go
create proc iud(@op int,@sid int,@sname varchar(20),@origin char(1),@type char(1))
as
begin
if(@op=1)
insert into Students values(@sid,@sname,@origin,@type)
else if(@op=2)
update Students set sid=@sid ,sname = @sname , ORIGIN =@origin , type = @type where sid=@sid
else if(@op=3)
delete from Students where sid=@sid 
else
print 'not valid op code select 1 for insert , 2 for update, 3 for delete '
select * from Students
end


		go
		exec iud 1,9,'bi','L','F'

		/* 
SID	SNAME	ORIGIN	TYPE
1	Hema	L	N
2	Ramya	F	F
3	Dhanusri	F	F
4	Nitya	F	F
5	Navya	L	F
6	mahesh	F	F
7	rakesh	F	F
9	bi		L	F
*/
		exec iud 2,9,'bin','F','N'
		/* 
		SID	SNAME	ORIGIN	TYPE
1	Hema	L	N
2	Ramya	F	F
3	Dhanusri	F	F
4	Nitya	F	F
5	Navya	L	F
6	mahesh	F	F
7	rakesh	F	F
9	bin	F	N
		*/

       exec iud 3,9,'bin','F','N'

	   /* 
	   SID	SNAME	ORIGIN	TYPE
1	Hema	L	N
2	Ramya	F	F
3	Dhanusri	F	F
4	Nitya	F	F
5	Navya	L	F
6	mahesh	F	F
7	rakesh	F	F
	   */
	   select * from Students

----------------------------------------------------------------------------------------------------------------------------------------------------

--7)List which course is taken maximum number of students?
select * from Courses where CID =
(SELECT c.CID FROM Admissions A, Courses c WHERE A.CID = c.CID
GROUP BY c.CID
HAVING count(*) =
(SELECT MAX (mycount) FROM
(SELECT COUNT(*) mycount FROM Admissions
GROUP BY CID) a))

/* output
CID	CNAME	shifts	Fees
2	Sql	Morning	18000.579
*/
---------------------------------------------------------------------------------------------------------------------------------------------------------


--8)Create trigger for admissions table if the admission is taken on ‘Sunday’
go
CREATE TRIGGER TR1 ON Admissions FOR INSERT AS
 BEGIN 
	IF DATENAME(DW,GETDATE())='SUNDAY'
	BEGIN
		ROLLBACK
		RAISERROR('CANT admit student ON SUNDAY',1,1)
	END
 END

 go
 
 insert into Admissions values(7, 3 , '2020/01/19', 'A')

 /* during sunday output
 CANT admit student ON SUNDAY
Msg 50000, Level 1, State 1
Msg 3609, Level 16, State 1, Line 239
The transaction ended in the trigger. The batch has been aborted.
 */

 drop trigger TR1
 select * from Admissions
 delete  admissions where sid = 7

 ---------------------------------------------------------------------------------------------------------------------------------------------------


 --9)Make function to get weekday for given Student id?
 go
create function weekdays (@sid int)
returns varchar(10)
as
begin
declare @doj varchar(10)
select @doj=Datename(dw,DOJ) from Admissions where sid=@sid
return @doj
end

go
select sid ,dbo.weekdays(sid) as weekday from Students
/* output 

sid	weekday
1	Friday
2	Wednesday
3	Friday
4	Sunday
5	Friday
6	Wednesday
7	NULL
*/


----------------------------------------------------------------------------------------------------------------------------------------------------------
--10)List which courses are common for 2 or more students?


select * from courses where cid in(select cid from ADMISSIONS group by cid having count(sid)>=2)

/* output 

CID	CNAME	shifts	Fees
2	Sql	Morning	18000.579
3	.Net	Evening	20000.00
*/

select * from Admissions
select * from Students
select * from Courses

-------------------------------------------------------------------------------------------------------------------------------------------------

--11)To define synonym for Students Master?


create synonym s2 for students
select * from s2

------------------------------------------------------------------------------------------------------------------------------------------------

--12)To define composite index on Doj,Grade?

CREATE NONCLUSTERED INDEX I1 ON ADMISSIONS(DOJ,GRADE)

drop index I1 on admissions


------------------------end of case study--------------------------------------------------------------






	













