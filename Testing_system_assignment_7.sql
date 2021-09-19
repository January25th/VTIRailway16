USE testingsystem;

DROP TRIGGER IF EXISTS trigger1;
DELIMITER $$
		CREATE TRIGGER trigger1
        BEFORE INSERT ON `Question`
        FOR EACH ROW
        BEGIN
        			IF NEW.CreateDate > now() THEN
			   SET NEW.CreateDate = now();
            END IF;
        END $$
DELIMITER ;
INSERT INTO Question 	(Content , CategoryID, TypeID, CreatorID, CreateDate)
VALUES					(n'Cau hoi',1,'1','1','2030-04-05');
SELECT *
FROM `Question`;       

-- Nho drop Trigger1 truoc khi chay Trigger2 
DROP TRIGGER IF EXISTS trigger2;
DELIMITER $$
		CREATE TRIGGER trigger2
        BEFORE INSERT ON `Question`
        FOR EACH ROW
        BEGIN
        
			IF NEW.CreateDate > now() THEN
			   SIGNAL SQLSTATE '12344' --
               SET MESSAGE_TEXT = " Time Input Error "; 
            END IF;
        END $$
DELIMITER ;

INSERT INTO Question 	(Content , CategoryID, TypeID, CreatorID, CreateDate)
VALUES					(n'Cau hoi',1,'1','1','2030-04-05');
SELECT *
FROM `Question`; 

-- Question 1: Tạo trigger không cho phép người dùng nhập vào Group có ngày tạo  trước 1 năm trước
DROP TRIGGER IF EXISTS trigger_1year_ago;
DELIMITER $$
		CREATE TRIGGER trigger_1year_ago
        BEFORE INSERT ON `Group`
        FOR EACH ROW
        BEGIN
			DECLARE v_Timestamp DATETIME;
            SET v_Timestamp = (DATE_SUB(NOW(), INTERVAL 1 YEAR));
			IF NEW.CreateDate < v_Timestamp THEN
			   SIGNAL SQLSTATE '12344' --
               SET MESSAGE_TEXT = " Time Input Error "; 
            END IF;
        END $$
DELIMITER ;

INSERT INTO `Group` (CreateDate)
VALUES					('2020-04-05');
SELECT *
FROM `Group`; 

-- Question 2: Tạo trigger Không cho phép người dùng thêm bất kỳ user nào vào department "Sale" nữa, 
-- Khi thêm thì hiện ra thông báo "Department "Sale" cannot add more user"
-- Bước 1: Viết Trigger khi Insert dữ liệu vào bảng 
-- Bước 2: Viết câu lênh Insert để Test dữ liệu
DROP TRIGGER IF EXISTS trigger_sale_department;
DELIMITER $$
		CREATE TRIGGER trigger_sale_department
        BEFORE INSERT ON department
        FOR EACH ROW
        BEGIN
			DECLARE v_Timestamp DATETIME;
            SET v_Timestamp = (DATE_SUB(NOW(), INTERVAL 1 YEAR));
			IF NEW.CreateDate < v_Timestamp THEN
			   SIGNAL SQLSTATE '12344' --
               SET MESSAGE_TEXT = " Time Input Error "; 
            END IF;
        END $$
DELIMITER ;

INSERT INTO Department (CreateDate)
VALUES					('2020-04-05');
SELECT *
FROM Department;

DROP TRIGGER IF EXISTS trigger_4;
DELIMITER $$
CREATE TRIGGER trigger_4
BEFORE UPDATE ON Question
FOR EACH ROW
	BEGIN
		IF OLD.TypeID = 1 THEN
			   SIGNAL SQLSTATE '12344' --
               SET MESSAGE_TEXT = " ko cho phep update "; 
            END IF;
	END $$
DELIMITER ;
UPDATE Question
SET Content = 'test123'
WHERE QuestionID = 1;
SELECT * FROM question;

-- Question 3: Cấu hình 1 group có nhiều nhất là 5 user
-- Khai báo biến var_CountGroupID để lấy số lượng account trong group cần Insert
-- Sử dụng NEW.GroupID để lấy giá trị GroupID cần Insert
DROP TRIGGER IF EXISTS TrG_GroupMaxAcc5;
DELIMITER $$
CREATE TRIGGER TrG_GroupMaxAcc5
 BEFORE INSERT ON `groupaccount`
 FOR EACH ROW
 BEGIN
DECLARE v_CountGroupID TINYINT;
SELECT count(GA.AccountID) INTO v_CountGroupID FROM groupaccount GA
WHERE GA.GroupID = NEW.GroupID;
IF (v_CountGroupID >5) THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = '1 group chỉ có nhiều nhất là 5 user';
END IF; 
 END$$
DELIMITER ;
-- Error Code: 1292. Incorrect datetime value: '2005' for column 'JoinDate' at row 1

SET foreign_key_checks = 0;
INSERT INTO groupaccount (GroupID,AccountID,JoinDate)
VALUES					(11,1,'2021-05-11'),
						(11,2,'2021-05-11'),
                        (11,3,'2021-05-11'),
                        (11,4,'2021-05-11'),
                        (11,5,'2021-05-11'),
                        (11,6,'2021-05-11');

-- Question 4: Cấu hình 1 bài thi có nhiều nhất là 10 Question
DROP TRIGGER IF EXISTS TrG_Limit10;
DELIMITER $$
CREATE TRIGGER TrG_Limit10
 BEFORE INSERT ON `examquestion`
 FOR EACH ROW
 BEGIN
DECLARE v_CountQues TINYINT;
SELECT count(EQ.QuestionID) INTO v_CountQues FROM examquestion EQ
WHERE EQ.ExamID = NEW.ExamID;
IF (v_CountQues >10) THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = 'Cấu hình 1 bài thi có nhiều nhất là 10 Question';
END IF; 
 END$$
DELIMITER ;
INSERT INTO `examquestion`(`ExamID`, `QuestionID`) 
VALUES 	(1,1),
		(1,2),
        (1,3),
        (1,4),
        (1,6),
        (1,7),
        (1,8),
        (1,9),
        (1,10),
        (1,11);

-- Question 5: Tạo trigger không cho phép người dùng xóa tài khoản có email là admin@gmail.com 
-- đây là tài khoản admin, không cho phép user xóa, còn lại các tài khoản khác thì sẽ cho phép xóa 
-- và sẽ xóa tất cả các thông tin liên quan tới user đó
-- Đang bị lỗiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
DROP TRIGGER IF EXISTS trg_delete_admin;
DELIMITER $$
CREATE TRIGGER trg_delete_admin
BEFORE DELETE ON `Account` 
FOR EACH ROW
BEGIN
DECLARE v_mail NVARCHAR(50);
SET v_mail = 'admin@gmail.com';
SELECT * FROM `account` a;
IF(a.Email = v_mail) THEN
SIGNAL SQLSTATE '12345'
SET MESSAGE_TEXT = 'đây là tài khoản admin, không cho phép user xóa';
 END IF;
END $$
DELIMITER ; 
DELETE FROM `account` A WHERE A.Email = 'admin@gmail.com';

-- Question 6: Không sử dụng cấu hình default cho field DepartmentID của table Account
-- hãy tạo trigger cho phép người dùng khi tạo account không điền vào departmentID thì sẽ được phân vào phòng ban "waiting Department"

DROP TRIGGER IF EXISTS Trg_Waiting;
DELIMITER $$
CREATE TRIGGER Trg_Waiting
BEFORE INSERT ON `account`
FOR EACH ROW
BEGIN
DECLARE v_Waiting VARCHAR(50);
SELECT D.DepartmentID INTO v_Waiting FROM department D WHERE D.DepartmentName = 'Waiting Department';
IF (NEW.DepartmentID IS NULL ) THEN
SET NEW.DepartmentID = v_Waiting;
 END IF;
END $$
DELIMITER ;
INSERT INTO `testingsystem`.`account` (`Email`, `Username`, `FullName`, `PositionID`, 
`CreateDate`) 
VALUES ('1',
'1', '1', '1', '2019-07-15 00:00:00');

-- Question 12: Lấy ra thông tin exam trong đó:
-- Duration <= 30 thì sẽ đổi thành giá trị "Short time"
-- 30 < Duration <= 60 thì sẽ đổi thành giá trị "Medium time"
-- Duration > 60 thì sẽ đổi thành giá trị "Long time"
SELECT *,
	CASE  
		WHEN Duration <= 60 THEN 'Short time'
		WHEN Duration > 60 && Duration <= 90 THEN 'Medium time'
		WHEN Duration > 90 THEN "Long Time"
		ELSE 'Can not define'
END AS Duration
FROM exam;