USE TestingSystem;

-- Question 2: lấy ra tất cả các phòng ban
SELECT * 
FROM Department;

-- Question 3: lấy ra id của phòng ban "Sale"
SELECT * 
FROM department
WHERE DepartmentName = 'Sale';

-- Question 4: lấy ra thông tin account có full name dài nhất
SELECT *
FROM `Account`
WHERE length(Fullname) = (	SELECT Max(length(Fullname)) 
							FROM `Account`)
ORDER BY Fullname ASC;

-- Question 5: Lấy ra thông tin account có full name dài nhất và thuộc phòng ban có id = 3
-- Để xuất ra đủ hết kết quả thì phải dùng SubQueries
SELECT *
FROM `Account`
WHERE DepartmentID=3 
AND length(Fullname) = (	SELECT Max(length(Fullname)) 
							FROM `Account`
                            WHERE DepartmentID=3);

-- Question 6: Lấy ra tên group đã tham gia trước ngày 20/12/2019
SELECT GroupName
FROM `group`
WHERE CreateDate < '2019-12-20 00:00:00';

-- Question 7: Lấy ra ID của question có >= 4 câu trả lời
-- Sau Where phải là tên 1 trường chứ không thể là một lệnh
SELECT *, count(AnswerID) AS SL
FROM answer
GROUP BY QuestionID
HAVING count(AnswerID) >=4;

-- Question 8: Lấy ra các mã đề thi có thời gian thi >= 60 phút và được tạo trước ngày  20/12/2019
SELECT *
FROM exam
WHERE Duration >=60 AND CreateDate < '2019-12-20 00:00:00';

-- Question 9: Lấy ra 5 group được tạo gần đây nhất
SELECT *
FROM `group`
ORDER BY CreateDate DESC
LIMIT 5;

-- Question 10: Đếm số nhân viên thuộc department có id = 2
SELECT DepartmentID, COUNT(AccountID)
FROM `Account`
WHERE DepartmentID = 2;

-- Group_Concat: hiện nhiều giá trị cùng lúc 
SELECT DepartmentID,COUNT(*),GROUP_CONCAT(AccountID),GROUP_CONCAT(Username)
FROM `Account`
GROUP BY DepartmentID 
HAVING COUNT(*) >= 2;

-- Question 11: Lấy ra nhân viên có tên bắt đầu bằng chữ "D" và kết thúc bằng chữ "o"
-- Phải nhớ dấu cách giữa 2 dấu nháy trong substring (Tên cột, '(đêm dựa trên khoảng trắng', vị trí -1 là đếm ngược) 
SELECT *
FROM `Account`
WHERE (SUBSTRING_INDEX(FullName, ' ', -1)) LIKE 'D%o';

-- Question 12: Xóa tất cả các exam được tạo trước ngày 20/12/2019

ALTER TABLE examquestion
DROP CONSTRAINT examquestion_ibfk_1;
ALTER TABLE examquestion
DROP CONSTRAINT examquestion_ibfk_2;

DELETE 
FROM Exam 
WHERE CreateDate < '2019-12-20';

-- Question 13: Xóa tất cả các question có nội dung bắt đầu bằng từ "câu hỏi"
DELETE 
FROM `question`
WHERE (SUBSTRING_INDEX(Content,' ',2)) ='Câu hỏi';

-- Question 14: Update thông tin của account có id = 5 thành tên "Nguyễn Bá Lộc" và email thành loc.nguyenba@vti.com.vn
UPDATE `Account`
SET Fullname = "Nguyễn Bá Lộc", Email ="loc.nguyenba@vti.com.vn"
WHERE AccountID = 5;

-- Question 15: update account có id = 5 sẽ thuộc group có id = 4
UPDATE `groupaccount`
SET AccountID = 5 
WHERE GroupID = 4;
