USE Testing_system;

-- Ctrl Alt để xóa nhanh
-- Lỗi khoảng trắng khi tab để nhập số
-- Lỗi TypeID chỉ có 2 giá trị nên chỉ nhập 1 vs 2 thôi
-- Lỗi nhập CHAR quên bỏ ký tự vào trong dấu nháy

INSERT INTO Department(DepartmentName)
VALUES				  (N'Kinh Doanh'),
					  (N'Quảng Cáo'	),
                      (N'Kế Toán'	),
                      (N'Nhân Sự'	),
                      (N'Kỹ Thuật');
-- SELECT * FROM Department;

INSERT INTO `Position`(PositionName)
VALUES				  (N'Dev'),
					  (N'Test'),
                      (N'Scrum Master'),
                      (N'PM');
-- SELECT * FROM `Position`;      

INSERT INTO `Account`(Email,					Username,		Fullname,		DepartmentID, 	PositionID)
VALUES				 ('thuyvi2501@gmail.com',	'thuyvi2501',	'Thụy Vi 1',1,1),
                     ('thuyvi2502@gmail.com',	'thuyvi2502',	'Thụy Vi 2',2,2),
					 ('thuyvi2503@gmail.com',	'thuyvi2503',	'Thụy Vi 3',3,3),    
					 ('thuyvi2504@gmail.com',	'thuyvi2504',	'Thụy Vi 4',4,4),
					 ('thuyvi2505@gmail.com',	'thuyvi2505',	'Thụy Vi 5',5,4);
                     
                     select * from Account;
                     
INSERT INTO `Group`(GroupName, 	CreatorID)
VALUE				 (N'Nhật',	1),
                     (N'Mỹ',	2),
                     (N'Trung',	3),
                     (N'Hàn',	4),
                     (N'Nga',	5);

INSERT INTO `GroupAccount`	(  GroupID	, AccountID	)
VALUES 						(	1		,    1		),
							(	2		,    2		),
							(	3		,    3		),
							(	4		,    4		),
							(	5		,    5		);

-- Error Code: 1265. Data truncated for column 'TypeName' at row 2
INSERT INTO TypeQuestion	(TypeName) 
VALUES 						('Essay'), 
							('Multiple-Choice'); 
                            
INSERT INTO CategoryQuestion(CategoryName)
VALUE				 ('Java'),
                     ('.Net'),
                     ('SQL'),
                     ('Postman'),
                     ('Ruby');   
                     
INSERT INTO 		Question(Content,		CategoryID,			TypeID,			CreatorID)
VALUE				 (N'Java là gì',1,1,1),
                     (N'.Net là gì',2,2,2),
                     (N'SQL là gì',3,1,3),
                     (N'Postman là gì',4,2,4),
                     (N'Ruby là gì',5,1,5);
                     
INSERT INTO 		Answer(Content, isCorrect)
VALUE				 (N'là Java',	true),
                     (N'là .Net',	true),
                     (N'là SQL',	true),
                     (N'là Postman',true),
                     (N'là Ruby',	true);
                     
INSERT INTO			Exam(`Code`,	Title,	CategoryID,		Duration,			CreatorID)
VALUE					('A',			N'Đề thi Java',1,15,1),
						('B',			N'Đề thi .Net',2,30,2),
                        ('C',			N'Đề thi SQL',3,45,3),
                        ('D',			N'Đề thi Postman',4,60,4),
                        ('E',			N'Đề thi Ruby',5,90,5);
                        
INSERT INTO			ExamQuestion(ExamID,	QuestionID)
VALUE							(1,1),
								(2,2),
                                (3,3),
                                (4,4),
                                (5,5);