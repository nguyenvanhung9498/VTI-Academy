
drop database if exists salemanagement;
CREATE DATABASE if not exists salemanagement;
use salemanagement;

CREATE TABLE Customer (
customer_id 		int,
customer_name		varchar(50),
date_of_perchase	date
);
CREATE TABLE department(
department_id	int,
department_name	varchar(50)
);
use salemanagement;
CREATE TABLE position (
positon_id	int,
position_name	varchar(50)
 );
 
CREATE TABLE  Account1 (
account_id int,
email	varchar(50),
fullname	varchar(50),
department_id	int,
position_id	int,
createdate	date
);

CREATE TABLE group1 (
group_id int,
group_name varchar(50),
creator_id int,
createdate date
);
CREATE TABLE GroupAccount (
group_id int,
group_name varchar(50),
join_date date
);
CREATE TABLE typequestion (
type_id int,
typename varchar(50)
);
CREATE TABLE categoryquestion (
category_id int,
category_name varchar(50)
);
CREATE TABLE question (
question_id int,
content varchar(50),
category_id int,
type_id varchar(50),
create_date date 
);
CREATE TABLE answer (
answer_id int,
content varchar(50),
category_id int,
creator_id int,
create_date date
);
CREATE TABLE exam (
exam_id int,
code_mdt int,
tile varchar(50),
category_id int,
duration int,
creator_id int,
creat_date date
);
CREATE TABLE examquestion (
exam_id int,
question_id int
);



