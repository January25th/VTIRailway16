USE TestingSystem;

-- Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
SELECT * 
FROM `account` a
JOIN department d ON d.departmentID = a.departmentID;

-- Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010
SELECT *
FROM `Account`
WHERE CreateDate < '2020-12-20';

-- Question 3: Viết lệnh để lấy ra tất cả các developer
SELECT *
FROM `Account` a 
JOIN Position p ON a.PositionID = p.PositionID
WHERE p.PositionName = 'Dev';

-- Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên
SELECT * , COUNT(a.DepartmentID)
FROM department d
JOIN `account` a ON d.DepartmentID = a.DepartmentID
-- WHERE không dùng được khi đếm hàm count
GROUP BY a.DepartmentID
HAVING COUNT(a.DepartmentID) >3;

-- CHIA NHỎ BÀI TOÁN RA ĐỂ LÀM

-- Question 5: Viết lệnh để **(lấy ra) danh sách *(câu hỏi được sử dụng trong đề thi nhiều nhất)
-- Không chạy được MAX COUNT cùng 1 lúc HAVING COUNT(QuestionID) = (SELECT Max(COUNT(QuestionID)) FROM examquestion);
SELECT content
FROM question q
JOIN examquestion eq ON q.QuestionID = eq.QuestionID
GROUP BY eq.QuestionID
HAVING COUNT(eq.QuestionID) = (	SELECT COUNT(QuestionID)
								FROM examquestion
								GROUP BY QuestionID
								ORDER BY COUNT(QuestionID) DESC
								LIMIT 1);
                                
-- Question 6: Thống kê mỗi Category Question được sử dụng trong bao nhiêu Question ???
-- B1 đếm Category Question thông qua Category ID
-- B2 nói ra rõ sử dụng trong Question nào thì phải Join bảng để lấy dữ liệu ra
SELECT *, COUNT(CategoryID), CategoryName
FROM question 
JOIN categoryquestion USING(CategoryID)
GROUP BY CategoryID;

-- Question 7: Thống kê mỗi Question được sử dụng trong bao nhiêu Exam
-- B1 Đếm số lần lặp của Question
-- B2 Nêu ra rõ trong kỳ thi nào 
SELECT *, COUNT(questionID)
FROM examquestion
JOIN exam USING(ExamID) 
GROUP BY QuestionID;

-- Question 8: Lấy ra Question có nhiều câu trả lời nhất
-- B1 Đếm số câu trả lời 
-- B2 Lấy ra cái có nhiều câu trả lời nhất
-- B3 Nêu nội dung
SELECT *
FROM question q
JOIN answer a ON q.QuestionID = a.QuestionID
GROUP BY a.QuestionID 
HAVING COUNT(a.QuestionID) = (SELECT COUNT(QuestionID)
							FROM answer
                            GROUP BY QuestionID
							ORDER BY COUNT(QuestionID) DESC
                            LIMIT 1);
                            
-- Question 9: Thống kê số lượng account trong mỗi group
-- B1 Đếm AccountID trong bảng GroupAccount
-- B2 Nêu ra trong Group = Join
SELECT g.GroupID, g.GroupName, COUNT(ga.AccountID)
FROM `group` g
LEFT JOIN groupaccount ga ON g.GroupID = ga.GroupID
GROUP BY g.GroupID;

-- Question 10: Tìm chức vụ có ít người nhất
-- B1 Đếm Position ID trong Account
-- B2 Join vs Position Name trong Position
SELECT p.PositionID, p.PositionName, COUNT(p.PositionID) AS SL
FROM `account` a
JOIN position p ON a.PositionID = p.PositionID
GROUP BY PositionID
HAVING COUNT(P.PositionID) = (	SELECT MIN(MinP) 
								FROM (	SELECT COUNT(a.PositionID) AS MinP 
										FROM `account` a
                                        GROUP BY a.PositionID  ) AS countP); 
-- HAVING COUNT(P.PositionID) = SELECT MIN(MinP) FROM CountP
-- MinP = SELECT COUNT(a.PositionID) AS MinP FROM `account` a GROUP BY a.PositionID (Tạo ra cột MinP để tìm giá trị Min)

-- Question 11: Thống kê mỗi phòng ban (department) có bao nhiêu dev, test, scrum master, PM (Position)
-- B1 nhóm DepartmentID trong `account`
-- B2 Join vs Department
SELECT DepartmentName, COUNT(a.PositionID), PositionName
FROM `Account` a 
JOIN department d ON a.DepartmentID = d.DepartmentID
JOIN position p ON a.PositionID = p.PositionID
GROUP BY a.DepartmentID, a.positionID;

-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, …
SELECT *
FROM question q
JOIN categoryquestion cq ON q.CategoryID = cq.CategoryID
JOIN `account` ac ON q.CreatorID = ac.AccountID
JOIN answer an ON q.QuestionID = an.QuestionID; 

-- Question 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm (TypeQuestion)
-- Thiếu Group By
SELECT tq.TypeName, COUNT(q.TypeID)
FROM question q
JOIN typequestion tq ON q.TypeID = tq.TypeID
GROUP BY q.TypeID;    

-- Question 14:Lấy ra group không có account nào
-- Nhìn hình ta có GroupID 24679 không có tồn tại trong bảng GA
SELECT * 
FROM `group` g
LEFT JOIN groupaccount ga ON g.GroupID = ga.GroupID
WHERE GA.AccountID IS NULL;   

-- Question 15: Lấy ra group không có account nào
SELECT * 
FROM groupaccount ga
RIGHT JOIN `group` g ON g.GroupID = ga.GroupID
WHERE GA.AccountID IS NULL;    

-- Question 16: Lấy ra question không có answer nào
SELECT q.Content         
FROM answer an 
RIGHT JOIN question q ON q.QuestionID = an.QuestionID
WHERE an.AnswerID IS NULL; 

-- Question 17: a) Lấy các account thuộc nhóm thứ 1 
SELECT A.FullName 
FROM `Account` A
JOIN GroupAccount GA ON A.AccountID = GA.AccountID
WHERE GA.GroupID = 1;

-- b) Lấy các account thuộc nhóm thứ 2 
SELECT A.FullName FROM `Account` A
JOIN GroupAccount GA ON A.AccountID = GA.AccountID
WHERE GA.GroupID = 2;

-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau
SELECT A.FullName
FROM `Account` A
JOIN GroupAccount GA ON A.AccountID = GA.AccountID
WHERE GA.GroupID = 1
UNION
SELECT A.FullName
FROM `Account` A
JOIN GroupAccount GA ON A.AccountID = GA.AccountID
WHERE GA.GroupID = 2;

-- Question 18: a) Lấy các group có lớn hơn 5 thành viên
SELECT g.GroupName, COUNT(ga.GroupID) AS SL
FROM GroupAccount ga
JOIN `Group` g ON ga.GroupID = g.GroupID
GROUP BY g.GroupID
HAVING COUNT(ga.GroupID) >= 5;

-- b) Lấy các group có nhỏ hơn 7 thành viên
SELECT g.GroupName, COUNT(ga.GroupID) AS SL
FROM GroupAccount ga
JOIN `Group` g ON ga.GroupID = g.GroupID
GROUP BY g.GroupID
HAVING COUNT(ga.GroupID) <= 7;

-- c) Ghép 2 kết quả từ câu a) và câu b)
SELECT g.GroupName, COUNT(ga.GroupID) AS SL
FROM GroupAccount ga
JOIN `Group` g ON ga.GroupID = g.GroupID
GROUP BY g.GroupID
HAVING COUNT(ga.GroupID) >= 5
UNION
SELECT g.GroupName, COUNT(ga.GroupID) AS SL
FROM GroupAccount ga
JOIN `Group` g ON ga.GroupID = g.GroupID
GROUP BY g.GroupID
HAVING COUNT(ga.GroupID) <= 7;