USE TestingSystem;

-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale
-- View
DROP VIEW IF EXISTS dsnv_sale;
CREATE VIEW dsnv_sale AS
		SELECT *
		FROM `account`
		JOIN department USING(departmentID)
        WHERE departmentname = 'Sale';	 
SELECT * FROM dsnv_sale;   

-- CTE
WITH dsnv_sale AS(
		SELECT *
		FROM `account`
		JOIN department USING(departmentID)
        WHERE departmentname = 'Sale')
SELECT * FROM dsnv_sale;        
        
-- Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
-- View
DROP VIEW IF EXISTS account_nangno;
CREATE VIEW account_nangno AS
SELECT  A.*, COUNT(ga.accountID), GROUP_CONCAT(GroupID)
FROM 	`account` a 
JOIN	`groupaccount` ga USING(AccountID)
GROUP BY a.AccountID
HAVING COUNT(ga.AccountID) = (SELECT  COUNT(ga.accountID)
							  FROM 	`account` a 
							  JOIN	`groupaccount` ga USING(AccountID)
							  GROUP BY a.AccountID
							  ORDER BY COUNT(ga.AccountID) DESC
                              LIMIT 1
							 );
SELECT *
FROM Account_nangno;

-- CTE
WITH CTE_account_nangno AS (
	SELECT COUNT(ga.AccountID) AS countAcc
    FROM groupaccount ga
    GROUP BY ga.AccountID
)
SELECT  A.*, COUNT(ga.accountID), GROUP_CONCAT(GroupID)
FROM 	`account` a 
JOIN	`groupaccount` ga USING(AccountID)
GROUP BY a.AccountID
HAVING COUNT(ga.AccountID) = (SELECT MAX(countAcc) AS maxAcc
							  FROM CTE_account_nangno);
                              
-- Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 20 từ được coi là quá dài) và xóa nó đi
-- View
DROP VIEW IF EXISTS short_questions;
CREATE VIEW short_questions AS (
SELECT * 
FROM question 
WHERE length(content)>20);

SET foreign_key_checks = 0;
DELETE FROM short_questions;

SELECT content FROM question;

-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
-- View
DROP VIEW IF EXISTS pbnnvn;
CREATE VIEW pbnnvn AS (
SELECT DepartmentName, Count(a.AccountID)
FROM `account` a 
JOIN department d USING(departmentID)
GROUP BY DepartmentID
HAVING count(a.AccountID) = (SELECT MAX(MaxAcc)
							FROM (SELECT COUNT(a.AccountID) As MaxAcc 
								  FROM `account` a
                                  GROUP BY a.DepartmentID
								  )AS CountAcc)
);                          
SELECT * FROM pbnnvn;
-- CTE
WITH CTE_pbnnvn AS (
	SELECT COUNT(a.AccountID) AS CountAcc
    FROM `account` a
    GROUP BY a.DepartmentID
    )
SELECT Departmentname, COUNT(a.accountID)
FROM `account` a
JOIN `department` d USING(DepartmentID)
GROUP BY a.DepartmentID
HAVING COUNT(a.AccountID) = (SELECT MAX(CountAcc) AS MaxAcc
							FROM CTE_pbnnvn);   
                            
-- Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo
DROP VIEW IF EXISTS User_Nguyen;
CREATE VIEW User_Nguyen AS ( 
SELECT a.fullName, q.Content
FROM question q
JOIN `account` a ON a.AccountID = q.CreatorID 
WHERE SUBSTRING_INDEX( a.FullName, ' ', 1 ) = 'Nguyễn');
SELECT * FROM User_Nguyen;                           
