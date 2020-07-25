-- assignment 5

-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale

create view child_account1 as
select *
from `account`
where departmentid = (select departmentid from department where departmentname='sale');

select * from child_account1;


WITH CTE_account AS
    (SELECT AccountID,FullName,Email,DepartmentID
    FROM
        account
    WHERE
        DepartmentID = 2)

SELECT *
FROM CTE_account;

-- Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
select * from groupaccount;

drop view if exists child_groupaccount1;
CREATE VIEW child_groupaccount1 AS
    SELECT 
        *, GROUP_CONCAT(groupid)
    FROM
        groupaccount
    GROUP BY accountid
    HAVING COUNT(1) = (	SELECT 
							COUNT(1)
						FROM
							groupaccount
						GROUP BY accountid
						ORDER BY COUNT(1) DESC
						LIMIT 1);

/*select count(1)
from groupaccount
group by accountid
order by count(1) desc 
limit 1*/
with CTE_child_groupaccount1 as
(SELECT 
        *, GROUP_CONCAT(groupid)
    FROM
        groupaccount
    GROUP BY accountid
    HAVING COUNT(1) = (	SELECT 
							COUNT(1)
						FROM
							groupaccount
						GROUP BY accountid
						ORDER BY COUNT(1) DESC
						LIMIT 1)
	)
select * from CTE_child_groupaccount1;



-- Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ
-- được coi là quá dài) và xóa nó đi

create view content_qua_dai as
select content
from question
having length(content)>300;
select* from content_qua_dai;

WITH CTE_content_qua_dai AS
    (select content
		from question
		having length(content)>300)
	SELECT * 
    FROM CTE_content_qua_dai;





-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
select * from `account`;
DROP VIEW IF EXISTS ds_phong_ban_nhieu_nv_nhat;
CREATE VIEW ds_phong_ban_nhieu_nv_nhat AS
    SELECT *,group_concat(FullName,accountid)
    FROM `account`
	JOIN
        department USING (departmentid)
    GROUP BY departmentid
    HAVING COUNT(1) = (SELECT 
							COUNT(1)
						FROM
							`account`
						GROUP BY departmentid
						ORDER BY COUNT(1) DESC
						LIMIT 1);
                        
                        
	WITH CTE_ds_phong_ban_nhieu_nv_nhat AS
    (SELECT *,group_concat(FullName,accountid)
    FROM `account`
	JOIN
        department USING (departmentid)
    GROUP BY departmentid
    HAVING COUNT(1) = (SELECT 
							COUNT(1)
						FROM
							`account`
						GROUP BY departmentid
						ORDER BY COUNT(1) DESC
						LIMIT 1))
	SELECT * 
    FROM CTE_ds_phong_ban_nhieu_nv_nhat;
                                
								


-- Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo
select * from account;
drop view if exists table_ho_nguyen;
create view table_ho_nguyen as
select a.AccountID,a.FullName,q.QuestionID,q.Content,q.CreateDate
from `account` a
join question q on a.accountid=q.creatorid
where fullname like 'nguyễn%'
group by questionid;

WITH CTE_table_ho_nguyen AS
    (select a.AccountID,a.FullName,q.QuestionID,q.Content,q.CreateDate
from `account` a
join question q on a.accountid=q.creatorid
where fullname like 'nguyễn%'
group by questionid)
	SELECT * 
    FROM CTE_table_ho_nguyen;