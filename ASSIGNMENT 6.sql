-- ASSIGNMENT 6

-- Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các
-- account thuộc phòng ban đó

USE TESTINGSYSTEM;

SELECT*FROM `ACCOUNT`;
DROP PROCEDURE IF EXISTS QUESTION1;
DELIMITER $$
CREATE PROCEDURE QUESTION1(IN TEN_PHONG_BAN VARCHAR(50))
BEGIN 
	SELECT *
    FROM `ACCOUNT`
    WHERE DEPARTMENTID =(SELECT DEPARTMENTID
							FROM DEPARTMENT
                            WHERE DEPARTMENTNAME=TEN_PHONG_BAN);
	END $$
DELIMITER ;



-- Question 2: Tạo store để in ra số lượng account trong mỗi group
SELECT *FROM `GROUP`;
DROP PROCEDURE IF EXISTS QUESTION2;
DELIMITER $$
CREATE PROCEDURE QUESTION2()
BEGIN 
	SELECT *,COUNT(ACCOUNTID),GROUP_CONCAT(ACCOUNTID)
    FROM `GROUPACCOUNT`
   GROUP BY GROUPID;
	END $$
DELIMITER ;


-- Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo
-- trong tháng hiện tại

DROP PROCEDURE IF EXISTS QUESTION3;
DELIMITER //
CREATE PROCEDURE QUESTION3()
BEGIN
		SELECT*,COUNT(1),GROUP_CONCAT(QUESTIONID)
        FROM QUESTION
        group by typeid
        having MONTH(CREATEDATE)=month(current_date());
END //
DELIMITER ;


-- Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất

DROP PROCEDURE IF EXISTS QUESTION4;
DELIMITER //
CREATE PROCEDURE QUESTION4()
BEGIN 
		SELECT TYPEID,COUNT(QUESTIONID),GROUP_CONCAT(QUESTIONID)
        FROM QUESTION
        GROUP BY TYPEID
        HAVING TYPEID = (SELECT TYPEID
							FROM QUESTION
                            GROUP BY TYPEID
                            HAVING COUNT(QUESTIONID)
                            ORDER BY COUNT(QUESTIONID) DESC
                            LIMIT 1);
END //
DELIMITER ;


-- Question 5: Sử dụng store ở question 4 để tìm ra tên của type question

DROP PROCEDURE IF EXISTS QUESTION5;
DELIMITER //
CREATE PROCEDURE QUESTION5()
BEGIN 
		SELECT * 
        FROM TYPEQUESTION
        WHERE TYPEID = (SELECT TYPEID
							FROM QUESTION
                            GROUP BY TYPEID
                            HAVING COUNT(QUESTIONID)
                            ORDER BY COUNT(QUESTIONID) DESC
                            LIMIT 1);
END //
DELIMITER ;


-- Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên
-- chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa chuỗi của
-- người dùng nhập vào

 drop procedure if exists question6;

DELIMITER $$

CREATE PROCEDURE QUESTION6(IN nhap_vao VARCHAR(100))

BEGIN

SELECT AccountID As ID,Username As `name`,1

FROM `account` a

WHERE Username LIKE CONCAT('%' , nhap_vao , '%')

UNION ALL

SELECT GroupID As ID,GroupName As `name`,2

FROM `group` a

WHERE GroupName LIKE CONCAT('%' , nhap_vao , '%');

END $$

DELIMITER ;


-- Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và
-- trong store sẽ tự động gán
-- username sẽ giống email nhưng bỏ phần @..mail đi, positionID: sẽ có default là developer, departmentID: sẽ được cho vào 1 phòng chờ
-- Sau đó in ra kết quả tạo thành công
select * from position;
drop procedure if exists question7;
delimiter //
create procedure question7(in nhap_email varchar(50), in nhap_fullname nvarchar(50))
begin 
		declare username1 varchar(150) default substring_index(nhap_email,'@',1);
		declare positionid1 tinyint default 1;
        declare departmentid1 tinyint default 10;
	insert into `account` (email,		fullname,		`positionid`,			username,		departmentid)
    values				  (nhap_email,	nhap_fullname,	positionid1,		username1,		departmentid1);
    select *
    from `account` a
    where a.email=nhap_email;

end //
delimiter ;

select*from `account`;
-- Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice
-- để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất

drop procedure if exists question8;
delimiter //
create procedure question8(in nhap_type_question_name varchar(20))
begin
	if nhap_type_question_name='essay' then 
			select typename, content,length(content)
		from question
        join typequestion using(typeid)
		where length(content)=(select length(content)
									from question 
									join typequestion using (typeid)
                                    where typeid=1
									group by questionid									
									order by length(content) desc
									limit 1);
		elseif nhap_type_question_name='multiple-choice' then
			select typename, content,length(content)
			from question
			join typequestion using(typeid)
			where length(content)=(select length(content)
									from question 
									join typequestion using (typeid)
                                    where typeid = 2
									group by questionid									
									order by length(content) desc
									limit 1);
		end if;
end //
delimiter ;


-- Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
select *from exam;
SET foreign_key_checks = 0;
DROP PROCEDURE IF EXISTS QUESTION9;
DELIMITER //
CREATE PROCEDURE QUESTION9(NHAP_ID TINYINT)
BEGIN 
		delete from exam
        where examid=NHAP_ID;

end //
delimiter ;

-- Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử
-- dụng store ở câu 9 để xóa), sau đó in số lượng record đã remove từ các table liên quan
-- trong khi removing


drop procedure if exists question10;
delimiter //
create procedure question10()
begin
		select * 
        from exam
        where year(createdate)=2019;
end //
delimiter ;

-- Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng
-- nhập vào tên phòng ban và các account thuộc phòng ban đó sẽ được chuyển về phòng
-- ban default là phòng ban chờ việc

DROP PROCEDURE IF EXISTS sp_DeleteDepartment;
DELIMITER $$
CREATE PROCEDURE sp_DeleteDepartment
(IN in_DepartmentName NVARCHAR(50))
BEGIN
		SET foreign_key_checks = 0;
		UPDATE `account`
		SET DepartmentID = 10
		WHERE DepartmentID = (SELECT DepartmentID
							  FROM Department
							  WHERE DepartmentName = in_DepartmentName);
		DELETE
		FROM Department
		WHERE DepartmentName = in_DepartmentName;
END$$
DELIMITER ;



-- Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay
select* from question;
drop procedure if exists question12;
delimiter //
create procedure question12()
begin
	select questionid,createdate,count(questionid)
    from question
    where year(createdate)=2020
    group by createdate;
end //
delimiter ;

-- Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6
-- tháng gần đây nhất (nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào
-- trong tháng")
drop procedure if exists question13;
delimiter //
create procedure question13()
begin
	select questionid,createdate,count(questionid)
    from question
    where datediff(current_date(),createdate)<=180
    group by createdate;
end //
delimiter ;



