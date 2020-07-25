
USE TESTINGSYSTEM;

-- QUESTION 1: VIẾT LỆNH ĐỂ LẤY RA DANH SÁCH NHÂN VIÊN VÀ THÔNG TIN PHÒNG BAN CỦA HỌ

SELECT FULLNAME,DEPARTMENTID,DEPARTMENTNAME
FROM `ACCOUNT` 
JOIN DEPARTMENT USING(DEPARTMENTID);

-- QUESTION 2: VIẾT LỆNH ĐỂ LẤY RA THÔNG TIN CÁC ACCOUNT ĐƯỢC TẠO SAU NGÀY 20/12/2010

SELECT USERNAME, CREATEDATE 
FROM `ACCOUNT` WHERE CREATEDATE >'2010-12-20';

-- QUESTION 3: VIẾT LỆNH ĐỂ LẤY RA TẤT CẢ CÁC DEVELOPER
SELECT* FROM POSITION
WHERE POSITIONNAME='DEV';

-- QUESTION 4: VIẾT LỆNH ĐỂ LẤY RA DANH SÁCH CÁC PHÒNG BAN CÓ >3 NHÂN VIÊN

SELECT *,COUNT(1) 
FROM `ACCOUNT`
GROUP BY DEPARTMENTID
HAVING COUNT(1) >3;


-- QUESTION 5: VIẾT LỆNH ĐỂ LẤY RA DANH SÁCH CÂU HỎI ĐƯỢC SỬ DỤNG TRONG ĐỀ THI NHIỀU
-- NHẤT

SELECT QUESTIONID,COUNT(QUESTIONID)
FROM examquestion
GROUP BY QUESTIONID
HAVING COUNT(QUESTIONID)= (SELECT COUNT(QUESTIONID)
							FROM	EXAMQUESTION
							GROUP BY QUESTIONID
							ORDER BY COUNT(QUESTIONID) DESC
							LIMIT 1); 

        
-- LẤY RA DANH SÁCH CÂU HỎI CÓ TẦN SUẤT XUẤT HIỆN TRONG ĐỀ THI NHIỀU NHẤT = 3
SELECT *,COUNT(1),GROUP_CONCAT(EXAMID)
FROM	EXAMQUESTION
GROUP BY QUESTIONID
HAVING COUNT(1) = 3;


-- QUESTION 6: THÔNG KÊ MỖI CATEGORY QUESTION ĐƯỢC SỬ DỤNG TRONG BAO NHIÊU QUESTION

SELECT *,COUNT(1), GROUP_CONCAT(QUESTIONID)
 FROM QUESTION 
GROUP BY CATEGORYID;


-- QUESTION 7: THÔNG KÊ MỖI QUESTION ĐƯỢC SỬ DỤNG TRONG BAO NHIÊU EXAM

SELECT *, COUNT(1)
FROM EXAMQUESTION
GROUP BY QUESTIONID;


-- QUESTION 8: LẤY RA QUESTION CÓ NHIỀU CÂU TRẢ LỜI NHẤT
SELECT *, COUNT(QUESTIONID)
FROM ANSWER
GROUP BY QUESTIONID
HAVING COUNT(QUESTIONID)=(SELECT COUNT(QUESTIONID)
							FROM ANSWER
                            group by QuestionID
                            order by COUNT(QUESTIONID) desc
                            limit 1);


-- QUESTION 9: THỐNG KÊ SỐ LƯỢNG ACCOUNT TRONG MỖI GROUP\
SELECT* FROM GROUPACCOUNT;


SELECT *, COUNT(1), GROUP_CONCAT(ACCOUNTID)
FROM GROUPACCOUNT
RIGHT JOIN `GROUP` USING(GROUPID)
GROUP BY GROUPID;


-- QUESTION 10: TÌM CHỨC VỤ CÓ ÍT NGƯỜI NHẤT

SELECT PositionName, COUNT(PositionID),group_concat(accountid)
FROM `account`
join `position` using(positionid)
GROUP BY PositionID
HAVING COUNT(PositionID)=(SELECT COUNT(positionid)
							FROM `account`
                            group by PositionID
                            order by COUNT(PositionID)
                            limit 1);
-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của
-- question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, …

select * 
from question q
join `account`a on a.accountid=q.creatorid;


-- Question 13: lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
select *,count(typeid)
from typequestion
join question using (typeid)
group by typeid;

-- Question 14: lấy ra group không có account nào
select *
from groupaccount;

select*
from `groupaccount`
 right join `group` using (groupid)
where accountid is null;


-- Question 15: lấy ra group không có account nào

-- Question 16: lấy ra question không có answer nào
select*
from `answer`
right join question using(questionid)
where answerid is null;


-- Exercise 2: Union
-- Question 17:
-- a) Lấy các account thuộc nhóm thứ 1
-- b) Lấy các account thuộc nhóm thứ 2
-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau

select accountid
from groupaccount
where groupid=1
union
select accountid
from groupaccount
where groupid=2;

-- Question 18:
-- a) Lấy các group có lớn hơn 5 thành viên
-- b) Lấy các group có nhỏ hơn 7 thành viên
-- c) Ghép 2 kết quả từ câu a) và câu b)

select *,count(AccountID),group_concat(accountid)
from groupaccount
group by groupid
having count(AccountID)>5
union
select *,count(AccountID),group_concat(accountid)
from groupaccount
group by groupid
having count(AccountID)<7;
