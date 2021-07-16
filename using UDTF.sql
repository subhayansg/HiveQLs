/*
Ename location1 location2
A  	  hyd 		bang

Expected output
Ename location
A          hyd
A         bang

*/

CREATE TABLE eloc (ename STRING, loc1 STRING, loc2 STRING);

INSERT INTO eloc VALUES ('A', 'Hyd', 'Bnglr');


select array(loc1,loc2) from eloc;
/*
+------------------+
|       _c0        |
+------------------+
| ["Hyd","Bnglr"]  |
+------------------+
*/

select explode(array(loc1,loc2)) as location from eloc; 
/*
+-----------+
| location  |
+-----------+
| Hyd       |
| Bnglr     |
+-----------+
*/

select ename, explode(array(loc1,loc2)) as location from eloc; -- This will fail as we can't have other columns with explode

-- For this we need Lateral view
SELECT ename, location
FROM eloc
LATERAL VIEW EXPLODE(ARRAY(loc1, loc2)) loc AS location;
/*
+--------+-----------+
| ename  | location  |
+--------+-----------+
| A      | Hyd       |
| A      | Bnglr     |
+--------+-----------+
*/

-- ===============================================================================================
/* Input
+----------------+--------------------+--------------------+--------------------+
| students.name  | students.subject1  | students.subject2  | students.subject3  |
+----------------+--------------------+--------------------+--------------------+
| Aditya         | Maths              | Science            | Social             |
| Satya          | Physics            | English            | Geography          |
| Priya          | Chemistry          | Maths              | Physics            |
+----------------+--------------------+--------------------+--------------------+
*/


/* Output
+---------+------------+
|  name   |  subjects  |
+---------+------------+
| Aditya  | Maths      |
| Aditya  | Science    |
| Aditya  | Social     |
| Satya   | Physics    |
| Satya   | English    |
| Satya   | Geography  |
| Priya   | Chemistry  |
| Priya   | Maths      |
| Priya   | Physics    |
+---------+------------+
*/


CREATE TABLE students(name STRING, subject1 STRING, subject2 STRING, subject3 STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/itv736079/students_data.txt'
INTO TABLE students;


SELECT name, subjects 
FROM students 
LATERAL VIEW EXPLODE(ARRAY(subject1,subject2,subject3)) subjects AS subjects;

--========================================================================================================
/* Input
+--------------+------------+
|   new2.id    | new2.name  |
+--------------+------------+
| [1,2,3,4,5]  | [a,b,c,d]  |
+--------------+------------+
*/

/* output

*/

CREATE TABLE new2(ID STRING, name STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' '
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/itv736079/new1.txt'
INTO TABLE new2;

SELECT id, name 
FROM new2 
LATERAL VIEW EXPLODE(ARRAY(id, name)) id AS id
LATERAL VIEW EXPLODE(name) name AS name;

SELECT id, name 
FROM students 
LATERAL VIEW EXPLODE(ARRAY(1,2,3,4,5)) subjects AS subjects;


select
   id,
   n as array_index,
   array_index( arr1, n ) as  val_1,
   array_index( arr2, n ) as  val_2
from
   ( select id, array(1,2,3,4,5) as arr1, array(a,b,c,d) as arr2) t
lateral view
   numeric_range( size( arr2 ) – 1 ) n1 as n