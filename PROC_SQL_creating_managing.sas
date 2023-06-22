* PROC SQL FUNDAMENTALS;
LIBNAME CERT '/home/u58028466/2023/cert';
data input27 ;
set cert.input27 ;
run;
proc sort data=input27 out=out27 ;
by country ;
run;
proc sql;
select distinct(upcase(state)) as state ,count(state) as state_count from out27
where upcase(state) in('PA' ,'FL' ,'CA')
group by upcase(state) 
having state_count
;
quit;

proc sql ;
select distinct(sex),
	round(avg(height)) as weight ,
	round(avg(weight)) as height ,
	round(median(height)) as med_weight ,
	min(height) as min_weight ,
	age
from sashelp.class 
group by age
having sex = 'F' & age > 12
;
run;

* Creating and Updating Tables and Views 
   * create a table (CREATE TABLE)
    update tables (UPDATE)
    alter existing tables
    delete a table
    create indexes
    use integrity constraints in table creation
    create views
;
PROC SQL;
* to define the columns and their attributes ;
CREATE TABLE Student_info (
	Student_name CHAR(20),
	DOB num informat = DATE9. Format = DATE9. ,
	ROll_no int 
);
* to verify that the table exists and to see the column attributes;
DESCRIBE TABLE Student_info ;
RUN ;
proc contents data=student_info ;
run;
* Update variable name and attributes;
proc sql ;
CREATE TABLE purchase_hist  AS 
SELECT DATE 'Puchase' informat= DATE9.,
Amount 'Sale' format=dollar9.0
from SASHELP.BUY;
SElECT * FROM purchase_hist; 
describe table purchase_hist;
run;
* to copy the column attribtes from one tale to another ;
PROC SQL ;
CREATE TABLE sale_history 
LIke purchase_hist ;
describe table sale_history ;
run;
* to copy the detials from the existing Table ;
* drop & keep in select statement;
PROC SQL;
CREATE TABLE copy_data AS
SELECT * FROM purchase_hist(drop=amount);
run;

* Inserting Rows into Tables ( to insert data values into tables)
   # Inserting Rows with the SET Clause 
   # Inserting Rows with the VALUES Clause
   # Inserting Rows with a Query
;

PROC SQL ;* using SET clause ;
DESCRIBE TABLE sale_history ;
Insert into sale_history 
SET Date = 56987 ,Amount= 85201
SET Date =58962 , Amount = 95623;
;
SELECT * FROM sale_history;
QUIT;
PROC SQL;* using Values clause;
INSERT INTO sale_history(Date,Amount)
Values (59786,231658)
Values		(45986,23598)
Values		(12548,32659);
run;
proc SQL;
SELECT * FROM sale_history;
run;

* using WHERE condition ;
proc print data=sashelp.birthwgt(obs=5);
var LowBirthWgt Drinking Death Smoking SomeCollege;
run;
PROC SQL ;
CREATE TABLE health LIKE sashelp.birthwgt
(keep= AgeGroup LowBirthWgt Drinking Smoking Death ) ;
INSERT INTO Health 
SELECT * FROM sashelp.birthwgt(keep= AgeGroup LowBirthWgt Drinking Smoking Death)
WHERE LowBirthWgt='Yes'& Drinking = 'Yes'& Smoking = 'Yes';
run;
PROC SQL ;
SELECT Distinct(AgeGroup),count(LowBirthWgt) AS low_weight
from health
GROUP BY  AgeGroup
;
run;

* to modify data values in tables and in the tables that underlie PROC SQL and SAS/ACCESS views
	UPDATE statement updates data in existing columns; it does not create new columns.
;
proc print data=cert.input36(obs=5 Drop=Member_ID) ;
var group ;
run;
proc SQl;
Create table member Like
cert.input36(drop=Member_ID);
INSERT INTO member
SELECT * FROM cert.input36(DROP=Member_ID);
UPDATE member SET Kilograms = Kilograms*1000 ;
UPDATE member SET Centimeters = Centimeters*0.01;
UPDATE member SET FirstName =UPCASE(FirstName);
UPDATE member SET LastName = UPCASE(LastName);
SELECT FirstName,MI,LastName,Kilograms as Grams ,
Centimeters as meters FROM member 
WHERE (not missing(Kilograms)) AND ( not missing(Centimeters));
QUIT;
* DELETE ROWS  & TABLE ;
PROC SQL ;
DELETE FROM member WHERE group ^= 'A'  ;
SELECT COUNT(group) FROM member ;
QUIT;
PROC SQL;* to delete entire table ;
DROP TABLE member ;
run;

* We can use the ALTER TABLE statement with tables only
it does not work with views
    Adding a Column
    Modifying a Column
    Deleting a Column
;
PROC FORMAT ;
Value BMI 
0-< 18 = 'under_weight'
18 -< 25 ='Healthy'
25 -< 30 = 'Over_weight'
30 -< 100 = 'Obese';
run;
PROC SQL;
ALTER TABLE member ADD Full_Name CHAR(50),BMI num format= numeric5.1 ,
Bmi_Status CHAR(15) ,delte char(2)  ;
ALTER TABLE member MODIFY delte char(2)'variable for drop'  ;
UPDATE member SET Full_name = 
PROPCASE(FirstName||' '||MI||'. '||LastName);
UPDATE member SET BMI = 
Kilograms*0.001/(Centimeters)**2;
UPDATE member SET Bmi_status = put(BMI,BMI.) ;
*DELETE FROM member WHERE missing(Bmi) ;
*DELETE FROM member WHERE Bmi_Status NOT
in('Obese','Over_weight','Healthy','under_weight');
DESCRIBE TABLE member ;
select Full_name, Bmi,Bmi_Status,delte From member ;
QUIT;
proc SQL ;
*ALTER TABLE member drop 
delte,FirstName,MI,LastName,BloodType,Kilograms,Centimeters ;
CREATE INDEX Full_name ON member ;* PRIMARY KEY;
SELECT * FROM member ; 
run;
* to change the width, informat, format, and label of a column;
* The DROP clause deletes columns from tables;

proc print data=member ;run;
PROC CONTENTS data= member ;run;
proc sql;
describe table member ;
run;

















