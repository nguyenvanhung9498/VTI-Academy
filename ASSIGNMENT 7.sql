-- ASSIGNMENT 7

-- Question 1: Tạo trigger không cho phép người dùng nhập vào Group có ngày tạo trước 1 năm trước


drop trigger if exists verify_create_date_on_group;
DELIMITER $$
create trigger verify_create_date_on_group
before insert on `group`
for each row
begin
	 if ( datediff(current_date(), new.createdate > 365)) then
	 signal sqlstate '10001'
	 set  message_text = 'năm tạo tối thiểu phải sau 1 năm';
	 end if;
	
end $$
delimiter ;


insert into `group` (GroupName		)
values				('grouptest2'		);
			
                    select* from `group`;




select * from examquestion;


-- Question 2: Tạo trigger Không cho phép người dùng thêm bất kỳ user nào vào
-- department "Sale" nữa, khi thêm thì hiện ra thông báo "Department "Sale" cannot add
-- more user"

drop trigger if exists add_sale_department;
delimiter $$

create trigger add_sale_department
before insert on department
for each row
begin
	if new.departmentname = 'sale' then signal sqlstate '10002'
    set message_text = 'department sale cannot add more user' ;
    end if;
    
    end $$
    delimiter ;

insert into department (departmentid,		departmentname)
values 					(11,				'sale');


-- QUESTION 3: CẤU HÌNH 1 GROUP CÓ NHIỀU NHẤT LÀ 5 USER
DROP TRIGGER IF EXISTS question3;
DELIMITER $$
CREATE TRIGGER question3
-- AFTER
BEFORE INSERT ON groupaccount
FOR EACH ROW
BEGIN
 IF (new.accountid in (select accountid
					from groupaccount
                    group by groupid
                    having count(accountid) >=5)) then
 -- 10000 - 45000
 SIGNAL SQLSTATE '10001' 
        SET MESSAGE_TEXT = '1 group co nhieu nhat 5 user';                
 END IF; 
END $$

-- Question 4: Cấu hình 1 bài thi có nhiều nhất là 5 Question

DROP TRIGGER IF EXISTS max_question;
DELIMITER $$
CREATE TRIGGER max_question
-- AFTER
BEFORE INSERT ON examquestion
FOR EACH ROW
BEGIN
 IF (new.examid  in (select examid
					from examquestion
                    group by examid
                    having count(questionid) >=5)) then
 -- 10000 - 45000
 SIGNAL SQLSTATE '10001' 
        SET MESSAGE_TEXT = '1 bai thi co nhieu nhat 5 question';                
 END IF; 
END $$
insert into examquestion (examid,questionid)-- ----------------------------------------------------
value                     (1,4);



-- Question 5: Tạo trigger không cho phép người dùng xóa tài khoản có email là
-- admin@gmail.com (đây là tài khoản admin, không cho phép user xóa), còn lại các tài
-- khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông tin liên quan tới user đó

DROP TRIGGER IF EXISTS DELETE_EMAIL;

DELIMITER $$
CREATE TRIGGER DELETE_EMAIL
BEFORE DELETE ON `ACCOUNT`
FOR EACH ROW
BEGIN
	IF OLD.EMAIL='ADMIN@GMAIL.COM' THEN 
		SIGNAL SQLSTATE '10003'
		SET MESSAGE_TEXT = 'ĐÂY LÀ TÀI KHOẢN ADMIN, KHÔNG CHO PHÉP USER XÓA';
    END IF;
END $$
DELIMITER ;
SELECT * FROM `ACCOUNT` ;
DELETE FROM `ACCOUNT` 
WHERE EMAIL='ADMIN@GMAIL.COM';	


-- Question 6: Không sử dụng cấu hình default cho field DepartmentID của table
-- Account, hãy tạo trigger cho phép người dùng khi tạo account không điền vào
-- departmentID thì sẽ được phân vào phòng ban "waiting Department"

drop trigger if exists question6;
delimiter //
create trigger question6
before insert on `account`
for each row
begin
		if new.departmentid is null then
        set new.departmentid=10;

end if;
end //
delimiter ;

-- Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi
-- question, trong đó có tối đa 2 đáp án đúng.
drop trigger if exists question7;
delimiter //
create trigger question7
before insert on 


-- Question 8: Viết trigger sửa lại dữ liệu cho đúng: nếu người dùng nhập vào gender
-- của account là nam, nữ, chưa xác định thì sẽ đổi lại thành M, F, U cho giống với cấu
-- hình ở database
drop trigger if exists auto_gender_update;
delimiter $$
create trigger auto_gender_update
before insert on `account`
for each row
begin
		if new.gender = 'nam' then
        set new.gender='m';
        elseif new.gender = 'nu'then
        set new.gender='f';
        elseif new.gender='chua xac dinh' then
        set new.gender='u';
	end if;
    end $$
    delimiter ;
    

-- Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày

drop trigger if exists xoa_bai_thi
delimiter $$
create trigger xoa_bai_thi
before delete on exam
for each row 
begin
	if ( datediff(current_date(),createdate <=2)) then
	 signal sqlstate '10004'
	set message_text = 'không được xóa bài thi mới tạo được 2 ngày';
    end if ;
end $$
delimiter ;


select* from exam;
insert into exam  			(	`code`,			`title`,			CategoryID,			Duration,		CreatorID,			CreateDate)
	values 					('vtiq011',		'đề thi toan',		11,					75,				11,					'2020-07-23');

-- Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, delete các
-- question khi question đó chưa nằm trong exam nào




-- Question 12: Lấy ra thông tin exam trong đó
-- Duration <= 30 thì sẽ đổi thành giá trị "Short time"
-- 30 < duration <= 60 thì sẽ đổi thành giá trị "Medium time"
-- duration >60 thì sẽ đổi thành giá trị "Long time"

SELECT ExamID,Title,`Code`,Duration,
	CASE 	WHEN Duration <= 30 THEN "Short time" 
            WHEN Duration > 30 and Duration <= 60 THEN "Medium time"
            WHEN Duration > 60 THEN "Long time"             
	END AS Duration
FROM exam;


-- Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên
-- là the_number_user_amount và mang giá trị được quy định như sau:
-- Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few
-- Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
-- Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher

select groupid,accountid, count(g.groupid),
case 	when count(g.groupid) <= 5 then 'few'
		when   20>= count(g.groupid) > 5 then 'normal'
        when count(g.groupid) > 20 then 'higher'
end as the_number_user_amount
from `account` a
join `group` g on a.accountid=g.creatorid
group by groupid;

-- Question 14: Thống kê số mỗi phòng ban có bao nhiêu user, nếu phòng ban nào
-- không có user thì sẽ thay đổi giá trị 0 thành "Không có User"

select* from `account`;



select departmentid,username, count(username),
case when count(username) = null then ' không có user'
end as user_moi_phong_ban
from `account` a
join department using(departmentid)
group by departmentid;