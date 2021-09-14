USE TestingSystem;

-- Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó
DROP PROCEDURE IF EXISTS get_all_acc_of_department;
DELIMITER $$
CREATE PROCEDURE get_all_acc_of_department(IN tenPhongBan NVARCHAR(50))
	BEGIN
		SELECT * FROM `account`
        JOIN department USING(departmentID)
        WHERE DepartmentName = 'Sale';
	END $$
DELIMITER ;	

CALL get_all_acc_of_department('Bảo vệ');

-- Question 2: Tạo store để in ra số lượng account trong mỗi group
DROP PROCEDURE IF EXISTS accnum_in_group;
DELIMITER $$
CREATE PROCEDURE accnum_in_group()
	BEGIN
		SELECT groupID, groupname, COUNT(ga.AccountID) , Group_Concat(ga.accountID)
        FROM `group`
        JOIN groupaccount ga USING(groupID)
        GROUP BY GroupID;
	END $$
DELIMITER ;	
CALL accnum_in_group();

-- Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại
-- Lệnh month vs year không với HAVING chỉ đi với WHERE
DROP PROCEDURE IF EXISTS quesnum;
DELIMITER $$
CREATE PROCEDURE quesnum()
	BEGIN
		SELECT TypeID, COUNT(q.QuestionID) , Group_Concat(q.questionID)
        FROM `question` q
        JOIN typequestion tq USING(typeID)
        WHERE month(q.CreateDate) = month(now()) AND year(q.CreateDate) = year(now())
        GROUP BY q.TypeID
        ;
	END $$
DELIMITER ;	

CALL quesnum();

-- Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất
DROP PROCEDURE IF EXISTS mostques;
DELIMITER $$
CREATE PROCEDURE mostques()
	BEGIN
		WITH CTE_CountID AS(
		SELECT count(q.TypeID) AS CountID
        FROM question q
		GROUP BY q.TypeID) 

		SELECT TypeID, TypeName , Group_Concat(q.questionID)
        FROM `question` q
        JOIN typequestion tq USING(typeID)
        GROUP BY q.TypeID
        HAVING COUNT(QuestionID) = (SELECT MAX(CountID)
								   FROM CTE_CountID)
        ;
	END $$
DELIMITER ;	

CALL mostquest;

-- Function chỉ trả ra 1 giá trị output
-- Procedure không có return, nên chỉ có function thôi
SET GLOBAL log_bin_trust_function_creators = 1;
-- Set câu ĐK để tạo FUNCTION, chỉ cần tạo 1 lần trong 1 file là được
DROP FUNCTION IF EXISTS tinhtong;
DELIMITER $$
CREATE FUNCTION tinhtong(number1 TINYINT, number2 TINYINT) RETURNS TINYINT
	BEGIN
		DECLARE tong TINYINT;
        SET tong = number1 + number2;
        RETURN tong;
    END$$
DELIMITER ;
SELECT tinhtong(1,3);    

-- Question 5: Sử dụng store ở question 4 để tìm ra tên của type question

-- Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và 
-- trả về group có tên chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa chuỗi của người dùng nhập vào
DROP PROCEDURE IF EXISTS search_by_keyword;
DELIMITER $$
CREATE PROCEDURE search_by_keyword(IN keyword NVARCHAR(50))
BEGIN
	SELECT g.GroupName 
    FROM `group` g 
    WHERE g.GroupName LIKE CONCAT("%",keyword,"%")
UNION
	SELECT a.Username 
    FROM `account` a 
    WHERE a.Username LIKE CONCAT("%",keyword,"%");
END$$
DELIMITER ;

CALL search_by_keyword ('co');

-- Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và trong store sẽ tự động gán:
-- username sẽ giống email nhưng bỏ phần @..mail đi
-- positionID: sẽ có default là developer
-- departmentID: sẽ được cho vào 1 phòng chờ 
-- Sau đó in ra kết quả tạo thành công

DROP PROCEDURE IF EXISTS insert_acc;
DELIMITER $$
CREATE PROCEDURE insert_acc(IN fullName NVARCHAR(50),
						    IN email	  NVARCHAR(50))
BEGIN
	DECLARE v_Username VARCHAR(50) DEFAULT SUBSTRING_INDEX(Email, '@', 1);
	-- DECLARE v_DepartmentID TINYINT UNSIGNED DEFAULT 1;
	-- DECLARE v_PositionID TINYINT UNSIGNED DEFAULT 1;
 
	INSERT INTO `account` (`Email`, `Username`, `FullName`, `DepartmentID`, `PositionID`, `CreateDate`) 
	VALUES (Email, v_Username, Fullname,1,1,NOW());
    SELECT 'Đã tạo thành công' AS KetQua;
END$$
DELIMITER ;

CALL insert_acc ('Nguyễn Sơn Tùng','skymtp456@gmail.com');

-- Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice 
-- để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất
DROP PROCEDURE IF EXISTS pick_one_choice;
DELIMITER $$
CREATE PROCEDURE pick_one_choice (IN TypeQuestion ENUM('Essay','Multiple-Choice'))
BEGIN
	-- Gọi x là biến / số ...
   DECLARE v_TypeID TINYINT UNSIGNED;
   -- Thế x = 3 ta có
   SELECT tq.TypeID INTO v_typeID FROM typequestion tq 
   WHERE tq.TypeName = TypeQuestion;
IF TypeQuestion = 'Essay' THEN 
WITH CTE_LengContent AS(
	SELECT length(q.Content) AS leng FROM question q
	WHERE TypeID = v_TypeID)
SELECT * FROM question q
WHERE TypeID = v_TypeID 
AND length(q.Content) = (SELECT MAX(leng) 
FROM CTE_LengthContent)
;
ELSEIF var_Choice = 'Multiple-Choice' THEN
WITH CTE_LengContent AS(
	SELECT length(q.Content) AS leng FROM question q
	WHERE TypeID = v_TypeID)
SELECT * FROM question q
WHERE TypeID = v_TypeID 
AND length(q.Content) = (SELECT MAX(leng) 
FROM CTE_LengContent)
;
END IF; 
END$$
DELIMITER ;

-- Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
-- Bảng Exam có liên kết khóa ngoại đến bảng examquestion vì vậy trước khi xóa dữ liệu trong 
-- bảng exam cần xóa dữ liệu trong bảng examquestion trước

DROP PROCEDURE IF EXISTS delete_by_ID;
DELIMITER $$
CREATE PROCEDURE delete_by_ID  (IN v_ID_Exam TINYINT UNSIGNED)
BEGIN
	-- Biến trung gian Declare khác với INPUT
	DECLARE ID_User TINYINT UNSIGNED;
    SELECT eq.ExamID INTO ID_User FROM examquestion eq
    WHERE eq.ExamID = v_ID_Exam;
	DELETE FROM examquestion eq WHERE ExamID = ID_User;
	DELETE FROM exam 		 e  WHERE ExamID = ID_User;
END$$ 
DELIMITER ;

CALL delete_by_ID(2);

-- Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi 
-- (sử dụng store ở câu 9 để xóa)
-- Sau đó in số lượng record đã remove từ các table liên quan trong khi removing
-- Trong bài này sử dụng kỹ thuật gọi Procedure trong Procedure.

DROP PROCEDURE IF EXISTS delete_3_years_ago;
DELIMITER $$
-- Đừng quên () nữa Vi ơi.
CREATE PROCEDURE delete_3_years_ago()
BEGIN
-- Không bôi Begin với End để chạy thử
-- Phải Declare để có biến trung gian in thông báo và chạy vòng lặp trong bài này
-- Nếu dùng cách bth thì không áp dụng được B9 cũng như không in được thông báo
	-- SELECT COUNT(ExamID)
    -- FROM Exam e
	-- WHERE year(e.CreateDate) <= (year(now()) - 3);
    -- DELETE FROM exam e 
    -- WHERE year(e.CreateDate) <= (year(now()) - 3);
    -- SELECT CONCAT("DELETE ", [Nó không hiểu Count(ExamID)]," IN Exam AND ", v_CountExamquestion ," IN 
-- Làm lại từ đầu
-- Khai báo biến sử dụng trong chương trình
	DECLARE v_ExamID TINYINT UNSIGNED;
	DECLARE v_CountExam TINYINT UNSIGNED DEFAULT 0;
	DECLARE v_CountExamquestion TINYINT UNSIGNED DEFAULT 0;
	DECLARE i TINYINT UNSIGNED DEFAULT 1;
	DECLARE in_thong_bao VARCHAR(50) ;
-- Tạo bảng tạm, tuy cồng kềnh so với cái bài này nhưng ứng dụng được nhiều về sau
DROP TABLE IF EXISTS delete_3_years_ago_Temp;
CREATE TABLE delete_3_years_ago_Temp(
	ID INT PRIMARY KEY AUTO_INCREMENT,
	ExamID INT);
-- Insert dữ liệu bảng tạm 
INSERT INTO delete_3_years_ago_Temp(ExamID)
	SELECT e.ExamID FROM exam e WHERE (year(now()) - year(e.CreateDate)) >2;
-- Lấy số lượng số Exam và ExamQuestion cần xóa.
 SELECT count(1) INTO v_CountExam FROM delete_3_years_ago_Temp;
 SELECT count(1) INTO v_CountExamquestion FROM examquestion eq
 INNER JOIN delete_3_years_ago_Temp dt ON eq.ExamID = dt.ExamID;
 
-- Thực hiện xóa trên bảng Exam và ExamQuestion sử dụng Procedure đã tạo ở Question9 bên trên
WHILE (i <= v_CountExam) DO
SELECT ExamID INTO v_ExamID FROM delete_3_years_ago_Temp WHERE ID = i;
CALL delete_by_ID(v_ExamID);
SET i = i +1;
END WHILE;
-- In câu thông báo 
	SELECT CONCAT("DELETE ",v_CountExam," IN Exam AND ", v_CountExamquestion ," IN ExamQuestion") 
	INTO in_thong_bao; 
	SIGNAL SQLSTATE '45000' 
	SET MESSAGE_TEXT = in_thong_bao; 
-- Xóa bảng tạm sau khi hoàn thành
	DROP TABLE IF EXISTS delete_3_years_ago_Temp; 
END$$ 
DELIMITER ;	

CALL delete_3_years_ago();

-- Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách 
-- người dùng nhập vào tên phòng ban và 
-- các account thuộc phòng ban đó sẽ được chuyển về phòng ban default là phòng ban chờ việc
DROP PROCEDURE IF EXISTS department_default; 
DELIMITER $$
CREATE PROCEDURE department_default (IN phong_ban NVARCHAR(20))
BEGIN
	-- Đặt sai kiểu dữ liệu tại Declare
	DECLARE v_phong_ban TINYINT UNSIGNED;
    SELECT d.departmentID INTO v_phong_ban 
    FROM department d
    WHERE d.departmentname = phong_ban;
    -- Update trong bảng account chứ không xóa trong bảng department để đảm bảo dữ liệu
    UPDATE `account` a SET a.DepartmentID = '1' WHERE a.DepartmentID = v_phong_ban;
	SET foreign_key_checks = 0;
	DELETE FROM department d WHERE d.DepartmentName = phong_ban;
END$$
DELIMITER ;

CALL department_default('Bảo vệ');

-- Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay.
-- Sử dụng CTE tạo 1 bảng tạm CTE_12Months để lưu thông tin 12 tháng
-- Sử dụng JOIN kết hợp điều kiện ON là M.MONTH = month(Q.CreateDate), ở đây ON là 1 hàm của CreateDate    

-- sp stored procedures    
-- Đặt tên bảng CTE là m    
DROP PROCEDURE IF EXISTS sp_CountQuesInMonth;
DELIMITER $$
CREATE PROCEDURE sp_CountQuesInMonth()
BEGIN
WITH CTE_12Months AS (
 SELECT 1 AS MONTH
 UNION SELECT 2 AS MONTH
 UNION SELECT 3 AS MONTH
 UNION SELECT 4 AS MONTH
 UNION SELECT 5 AS MONTH
 UNION SELECT 6 AS MONTH
 UNION SELECT 7 AS MONTH
 UNION SELECT 8 AS MONTH
 UNION SELECT 9 AS MONTH
 UNION SELECT 10 AS MONTH
 UNION SELECT 11 AS MONTH
 UNION SELECT 12 AS MONTH
)
SELECT M.MONTH, count(month(Q.CreateDate)) AS SL
FROM CTE_12Months M LEFT JOIN (SELECT * FROM question Q1 WHERE year(Q1.CreateDate) = year(now()) ) Q 
-- Q là bảng chứa tất cả các tháng trong năm nay
ON M.MONTH = month(Q.CreateDate) 
GROUP BY M.MONTH;
END$$
DELIMITER ;
Call sp_CountQuesInMonth();

-- Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6 tháng gần đây nhất
-- (Nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào trong tháng")
DROP PROCEDURE IF EXISTS sp_CountQuesBefore6Month;
DELIMITER $$
-- date_sub là phép trừ 
-- interval = khoảng thời gian
CREATE PROCEDURE sp_CountQuesBefore6Month()
BEGIN
WITH CTE_Talbe_6MonthBefore AS (
SELECT MONTH(DATE_SUB(NOW(), INTERVAL 5 MONTH)) AS MONTH, 
YEAR(DATE_SUB(NOW(), INTERVAL 5 MONTH)) AS `YEAR`
UNION
SELECT MONTH(DATE_SUB(NOW(), INTERVAL 4 MONTH)) AS MONTH, 
YEAR(DATE_SUB(NOW(), INTERVAL 4 MONTH)) AS `YEAR`
UNION
SELECT MONTH(DATE_SUB(NOW(), INTERVAL 3 MONTH)) AS MONTH, 
YEAR(DATE_SUB(NOW(), INTERVAL 3 MONTH)) AS `YEAR`
UNION
SELECT MONTH(DATE_SUB(NOW(), INTERVAL 2 MONTH)) AS MONTH, 
YEAR(DATE_SUB(NOW(), INTERVAL 2 MONTH)) AS `YEAR`
UNION
SELECT MONTH(DATE_SUB(NOW(), INTERVAL 1 MONTH)) AS MONTH, 
YEAR(DATE_SUB(NOW(), INTERVAL 1 MONTH)) AS `YEAR`
UNION
SELECT MONTH(NOW()) AS MONTH, YEAR(NOW()) AS `YEAR`
)
SELECT M.MONTH,M.YEAR, (CASE 
-- Từ Case đến End là 1 câu lệnh
WHEN COUNT(QuestionID) = 0 THEN 'không có câu hỏi nào trong tháng'
ELSE COUNT(QuestionID)
END) AS SL
FROM CTE_Talbe_6MonthBefore M
LEFT JOIN (SELECT * FROM question where CreateDate >= DATE_SUB(NOW(), 
INTERVAL 6 MONTH) AND CreateDate <= now()) 
-- đặt điều kiện chặn các dữ liệu có ngày tháng năm ở tương lai hoặc hơn 6 tháng
AS Sub_Question ON M.MONTH = 
-- Sub_Question là Bảng bên phải của Join
MONTH(CreateDate)
GROUP BY M.MONTH
ORDER BY M.MONTH ASC;
END$$
DELIMITER ;
-- Run: 
CALL sp_CountQuesBefore6Month;

-- BONUS THÊM VỀ FUNCTION: Nhập vào DepartmentID sau đó sử dụng function để in ra DepartmentName
SET GLOBAL log_bin_trust_function_creators = 1;
DROP FUNCTION IF EXISTS function_getNameDep;
DELIMITER $$ 
CREATE FUNCTION function_getNameDep (var1 TINYINT) RETURNS VARCHAR(100)
BEGIN
DECLARE var_Name VARCHAR(100);
 SET var_Name ='';
 -- SET giá trị default để chương trình ko bị lỗi
 SELECT d.DepartmentName INTO var_Name FROM department d WHERE d.DepartmentID = 
var1;
RETURN var_Name;
END$$
DELIMITER ;
SELECT function_getNameDep(3)